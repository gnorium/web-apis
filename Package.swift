// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WebAPIs",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WebAPIs",
            targets: ["WebAPIs"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/gnorium/web-types", from: "1.0.0"),
        .package(url: "https://github.com/gnorium/embedded-swift-utilities", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "WebAPIs",
            dependencies: [
                .product(name: "WebTypes", package: "web-types"),
                .product(name: "Utilities", package: "embedded-swift-utilities")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("StrictConcurrency"),
                .unsafeFlags(["-warn-concurrency"], .when(configuration: .debug)),
            ]
        ),
        .testTarget(
            name: "WebAPIsTests",
            dependencies: ["WebAPIs"]
        ),
    ]
)
