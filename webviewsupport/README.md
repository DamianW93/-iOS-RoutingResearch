# WebViewSupport

A small abstraction over `WKWebView` providing:

- Coordinator object to manage a shared web view instance
- Cookie setup
- JavaScript message handling via `WKScriptMessageHandler`
- Bridging DOM CustomEvents to native handlers
- Native-to-JS event dispatch and arbitrary JS evaluation
- SwiftUI `WebView` wrapper for easy embedding in views

## Usage

```swift
import WebViewSupport
import SwiftUI

final class Receiver: WebViewScriptMessageReceiver {
    func didReceiveScriptMessage(name: String, body: Any, webView: WebViewProxy) {
        print("message", name, body)
    }
}

struct MyWebScreen: View {
    @StateObject private var coordinator: WebViewCoordinator
    private let receiver = Receiver()

    init() {
        let url = URL(string: "https://example.com")!
        let config = WebViewSetupConfiguration(
            initialURL: url,
            bridgeDOMEvents: ["fromJsEvent"]
        )
        let c = WebViewCoordinator(configuration: config)
        c.addScriptMessageReceiver(name: "fromJsEvent", receiver: receiver)
        _coordinator = StateObject(wrappedValue: c)
    }

    var body: some View {
        WebView(coordinator: coordinator)
    }
}
```

### Sending an event to the page
```swift
coordinator.sendCustomEvent(name: "nativeEvent", detailJSONObject: ["foo": "bar"]) 
```

### Receiving events from the page
In JS, either call a message handler directly:
```js
action.onclick = () => window.webkit.messageHandlers.fromJsEvent.postMessage({ id: 42 });
```
Or dispatch a DOM event that the coordinator bridges:
```js
window.dispatchEvent(new CustomEvent('fromJsEvent', { detail: { id: 42 } }));
```