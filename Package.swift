// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "TreeView",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "TreeView", targets: ["TreeView"]),
    ],
    targets: [
        .target(name: "TreeView"),
    ]
)
