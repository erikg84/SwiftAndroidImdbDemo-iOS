// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftAndroidSDKPackage",
    platforms: [.iOS(.v15)],
    dependencies: [
        .package(id: "dallaslabs-sdk.swift-android-sdk", from: "1.1.7"),
    ],
    targets: []
)
