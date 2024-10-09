// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LockScreenView",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LockScreenView",
            targets: ["LockScreenView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LockScreenView"),
        .testTarget(
            name: "LockScreenViewTests",
            dependencies: ["LockScreenView"]),
    ]
)
