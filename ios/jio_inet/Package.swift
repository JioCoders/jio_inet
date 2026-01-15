// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "jio_inet",
    platforms: [.iOS(.v10)], // Set the minimum iOS version
    products: [
        .library(
            name: "jio_inet",
            targets: ["jio_inet"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "jio_inet",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            // path: "path/to/source"),
            path: "ios/Classes",
            publicHeadersPath: "" // Specify if there are public headers
        )
    ]
)
