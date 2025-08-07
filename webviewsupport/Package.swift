// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "webviewsupport",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WebViewSupport", targets: ["WebViewSupport"]) 
    ],
    targets: [
        .target(name: "WebViewSupport"),
        .testTarget(name: "WebViewSupportTests", dependencies: ["WebViewSupport"]) 
    ]
)