// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2021",
    dependencies: [
      .package(
        url: "https://github.com/apple/swift-collections.git",
        .upToNextMajor(from: "1.0.0")
      )
    ],
    targets: [
        .executableTarget(name: "01"),
        .executableTarget(name: "02"),
        .executableTarget(name: "03"),
        .executableTarget(name: "04"),
        .executableTarget(name: "05"),
        .executableTarget(name: "06"),
        .executableTarget(name: "07"),
        .executableTarget(name: "08"),
        .executableTarget(name: "09"),
        .executableTarget(name: "10", dependencies: [.product(name: "Collections", package: "swift-collections")])
    ]
)
