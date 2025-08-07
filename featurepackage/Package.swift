// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "featurepackage",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "FeaturePackage", targets: ["FeaturePackage"]) 
    ],
    dependencies: [
        .package(path: "../webviewsupport")
    ],
    targets: [
        .target(name: "FeaturePackage", dependencies: [
            .product(name: "WebViewSupport", package: "webviewsupport")
        ]),
        .testTarget(name: "FeaturePackageTests", dependencies: ["FeaturePackage"]) 
    ]
)