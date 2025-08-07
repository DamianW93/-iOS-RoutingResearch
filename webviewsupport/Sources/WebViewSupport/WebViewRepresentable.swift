import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    private let viewModel: WebViewViewModel

    public init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> WKWebView {
        viewModel.webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // Updates are driven through the view model.
    }
}