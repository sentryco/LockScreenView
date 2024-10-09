// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LockScreenView",
    platforms: [
      .macOS(.v14),
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "LockScreenView",
            targets: ["LockScreenView"]),
    ],
    dependencies: [
      .package(url: "https://github.com/sentryco/HybridColor", branch: "main"),
      .package(url: "https://github.com/sentryco/BlurView", branch: "main"),
      .package(url: "https://github.com/sentryco/HapticFeedback", branch: "main")
    ],
    targets: [
        .target(
            name: "LockScreenView",
            dependencies: [
               .product(name: "HybridColor", package: "HybridColor"),
               .product(name: "BlurView", package: "BlurView"),
               .product(name: "HapticFeedback", package: "HapticFeedback")
            ]),
        .testTarget(
            name: "LockScreenViewTests",
            dependencies: ["LockScreenView"]),
    ]
)
