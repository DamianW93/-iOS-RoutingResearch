import Foundation
import WebKit
import SwiftUI

public protocol WebViewProxy: AnyObject {
    func evaluateJavaScript(_ js: String, completion: ((Result<Any?, Error>) -> Void)?)
    func sendCustomEvent(name: String, detailJSONObject: Any)
}

public protocol WebViewScriptMessageReceiver: AnyObject {
    func didReceiveScriptMessage(name: String, body: Any, webView: WebViewProxy)
}

public struct WebViewSetupConfiguration {
    public var initialURL: URL?
    public var cookies: [HTTPCookie]
    public var allowsBackForwardNavigationGestures: Bool
    public var customUserScripts: [WKUserScript]
    public var bridgeDOMEvents: [String]

    public init(
        initialURL: URL?,
        cookies: [HTTPCookie] = [],
        allowsBackForwardNavigationGestures: Bool = true,
        customUserScripts: [WKUserScript] = [],
        bridgeDOMEvents: [String] = []
    ) {
        self.initialURL = initialURL
        self.cookies = cookies
        self.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        self.customUserScripts = customUserScripts
        self.bridgeDOMEvents = bridgeDOMEvents
    }
}

public final class WebViewCoordinator: NSObject, ObservableObject, WebViewProxy {
    let webView: WKWebView
    private let userContentController: WKUserContentController

    private final class WeakBox {
        weak var receiver: WebViewScriptMessageReceiver?
        init(_ r: WebViewScriptMessageReceiver) { self.receiver = r }
    }

    private var nameToReceiver: [String: WeakBox] = [:]

    public init(configuration: WebViewSetupConfiguration = .init(initialURL: nil)) {
        let config = WKWebViewConfiguration()
        let ucc = WKUserContentController()
        config.userContentController = ucc
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        self.userContentController = ucc
        self.webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = configuration.allowsBackForwardNavigationGestures

        for script in configuration.customUserScripts {
            ucc.addUserScript(script)
        }
        if !configuration.bridgeDOMEvents.isEmpty {
            let scriptSource = Self.makeDOMBridgeScript(for: configuration.bridgeDOMEvents)
            let bridgeScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            ucc.addUserScript(bridgeScript)
            for name in configuration.bridgeDOMEvents {
                ucc.add(self, name: name)
            }
        }

        if let url = configuration.initialURL {
            setCookies(configuration.cookies) { [weak self] in
                self?.load(url: url)
            }
        } else if !configuration.cookies.isEmpty {
            setCookies(configuration.cookies, completion: nil)
        }
    }

    public func load(url: URL) {
        webView.load(URLRequest(url: url))
    }

    public func setCookies(_ cookies: [HTTPCookie], completion: (() -> Void)?) {
        guard !cookies.isEmpty else {
            completion?()
            return
        }
        let store = webView.configuration.websiteDataStore.httpCookieStore
        let group = DispatchGroup()
        for cookie in cookies {
            group.enter()
            store.setCookie(cookie) {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion?()
        }
    }

    public func addScriptMessageReceiver(name: String, receiver: WebViewScriptMessageReceiver) {
        nameToReceiver[name] = WeakBox(receiver)
        userContentController.add(self, name: name)
    }

    public func removeScriptMessageReceiver(name: String) {
        nameToReceiver[name] = nil
        userContentController.removeScriptMessageHandler(forName: name)
    }

    deinit {
        for key in nameToReceiver.keys {
            userContentController.removeScriptMessageHandler(forName: key)
        }
        // Remove any handlers registered for bridged events too
        let registeredNames = userContentController.value(forKey: "_messageHandlerNames") as? [String] ?? []
        for name in registeredNames {
            userContentController.removeScriptMessageHandler(forName: name)
        }
    }

    public func evaluateJavaScript(_ js: String, completion: ((Result<Any?, Error>) -> Void)? = nil) {
        webView.evaluateJavaScript(js) { result, error in
            if let error { completion?(.failure(error)) }
            else { completion?(.success(result)) }
        }
    }

    public func sendCustomEvent(name: String, detailJSONObject: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: ["detail": detailJSONObject], options: []),
              let json = String(data: data, encoding: .utf8) else {
            return
        }
        let js = """
        (function() {
            try {
                const payload = \(json);
                const event = new CustomEvent('\(name)', { detail: payload.detail });
                window.dispatchEvent(event);
            } catch (e) { console.error('sendCustomEvent error', e); }
        })();
        """
        evaluateJavaScript(js, completion: nil)
    }

    private static func makeDOMBridgeScript(for eventNames: [String]) -> String {
        let list = eventNames.map { "'\($0)'" }.joined(separator: ",")
        return """
        (function() {
            const names = [\(list)];
            names.forEach(function(name) {
                window.addEventListener(name, function(e) {
                    try {
                        var body = e && typeof e.detail !== 'undefined' ? e.detail : null;
                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers[name]) {
                            window.webkit.messageHandlers[name].postMessage(body);
                        }
                    } catch (err) {
                        console.error('DOM bridge error for', name, err);
                    }
                });
            });
        })();
        """
    }
}

extension WebViewCoordinator: WKNavigationDelegate {}

extension WebViewCoordinator: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let receiver = nameToReceiver[message.name]?.receiver {
            receiver.didReceiveScriptMessage(name: message.name, body: message.body, webView: self)
        }
    }
}