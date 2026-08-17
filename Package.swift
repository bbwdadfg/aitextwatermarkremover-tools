// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AtwrTools",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AtwrTools", targets: ["AtwrTools"])
    ],
    targets: [
        .target(name: "AtwrTools"),
        .testTarget(name: "AtwrToolsTests", dependencies: ["AtwrTools"])
    ]
)
