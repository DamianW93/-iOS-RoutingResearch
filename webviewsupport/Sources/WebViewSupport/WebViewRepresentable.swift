import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    private let coordinatorObject: WebViewCoordinator

    public init(coordinator: WebViewCoordinator) {
        self.coordinatorObject = coordinator
    }

    public func makeUIView(context: Context) -> WKWebView {
        coordinatorObject.webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // Updates are coordinated through the coordinator instance.
    }
}