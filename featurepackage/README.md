# FeaturePackage

Demonstrates consuming the `WebViewSupport` package from a feature module.

- Provides `FeatureWebViewScreen` SwiftUI view as an example.
- Shows how to register JS message receivers and send native events.

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

Use the sample view or compose your own with the coordinator.