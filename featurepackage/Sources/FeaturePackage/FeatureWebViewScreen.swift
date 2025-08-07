import SwiftUI
import WebViewSupport

final class ExampleReceiver: WebViewScriptMessageReceiver {
    func didReceiveScriptMessage(name: String, body: Any, webView: WebViewProxy) {
        print("Received JS message:", name, body)
    }
}

public struct FeatureWebViewScreen: View {
    @StateObject private var coordinator: WebViewCoordinator
    private let receiver = ExampleReceiver()

    public init() {
        let url = URL(string: "https://apple.com")!

        let cookies: [HTTPCookie] = []

        let config = WebViewSetupConfiguration(
            initialURL: url,
            cookies: cookies,
            allowsBackForwardNavigationGestures: true,
            customUserScripts: [],
            bridgeDOMEvents: ["fromJsEvent"]
        )
        let coord = WebViewCoordinator(configuration: config)
        coord.addScriptMessageReceiver(name: "fromJsEvent", receiver: receiver)
        _coordinator = StateObject(wrappedValue: coord)
    }

    public var body: some View {
        VStack(spacing: 12) {
            WebView(coordinator: coordinator)
            HStack(spacing: 12) {
                Button("Send event to JS") {
                    coordinator.sendCustomEvent(name: "nativeEvent", detailJSONObject: ["foo": "bar"]) 
                }
                Button("Eval JS") {
                    coordinator.evaluateJavaScript("document.body.style.backgroundColor = 'lightyellow'")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
}