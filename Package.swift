// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationClient",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .singleTargetLibrary("NotificationClient"),
        .singleTargetLibrary("NotificationClientLive"),
        .singleTargetLibrary("NotificationClientUI"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", branch: "main"),
		.package(url: "https://github.com/ThanhHaiKhong/NetworkClient.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "NotificationClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "NetworkClient", package: "NetworkClient"),
            ]
        ),
        .target(
            name: "NotificationClientLive",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "NetworkClientLive", package: "NetworkClient"),
                "NotificationClient",
            ]
        ),
        .target(
            name: "NotificationClientUI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "NotificationClient",
                "NotificationClientLive",
            ]
        ),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
