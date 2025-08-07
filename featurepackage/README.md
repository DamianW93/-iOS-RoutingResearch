# FeaturePackage

Demonstrates consuming the `WebViewSupport` package from a feature module using the coordinator-based API.

- Provides `FeatureWebViewScreen` SwiftUI view as an example.
- Shows how to register JS message receivers and send native events via the coordinator.

## Integration

Add this package to your app and ensure `webviewsupport` is available as a local package dependency:

```swift
// In Package.swift of the app or workspace
.package(path: "../webviewsupport")
```

Then depend on the product:
```swift
.target(
    name: "YourFeature",
    dependencies: [ .product(name: "WebViewSupport", package: "webviewsupport") ]
)
```

Use the coordinator to create the SwiftUI view and interact with the WebView through the abstraction only.