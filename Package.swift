// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftAndroidSDKPackage",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "SwiftAndroidSDK", targets: ["SwiftAndroidSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "SwiftAndroidSDK",
            url: "https://storage.googleapis.com/dallaslabs-sdk-artifacts/maven/com/dallaslabs/sdk/swift-android-sdk-ios/1.1.6/swift-android-sdk-ios-1.1.6.zip",
            checksum: "3f5ae3760cc1c4b6ba4f9a4d055f3a89bd0bb09b4e07d4335c312a8c41dc9074"
        ),
    ]
)
