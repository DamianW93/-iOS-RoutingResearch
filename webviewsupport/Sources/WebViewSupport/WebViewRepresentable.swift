import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    private let viewModel: WebViewViewModel

    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> WKWebView {
        viewModel.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Updates are driven through the view model.
    }
}

public struct WebViewContainerView: View {
    @ObservedObject private var coordinator: WebViewCoordinator

    public init(coordinator: WebViewCoordinator) {
        self.coordinator = coordinator
    }

    public var body: some View {
        coordinator.makeView()
    }
}