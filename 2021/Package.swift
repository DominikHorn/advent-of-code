// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2021",
    dependencies: [],
    targets: [
        .executableTarget(name: "01"),
        .executableTarget(name: "02"),
        .executableTarget(name: "03"),
        .executableTarget(name: "04"),
        .executableTarget(name: "05")
    ]
)
