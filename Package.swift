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
        .package(url: "https://github.com/gnorium/web-types", branch: "main"),
        .package(url: "https://github.com/gnorium/embedded-swift-utilities", branch: "main")
    ],
    targets: [
        .target(
            name: "WebAPIs",
            dependencies: [
                .product(name: "WebTypes", package: "web-types"),
                .product(name: "EmbeddedSwiftUtilities", package: "embedded-swift-utilities")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("Extern")
            ]
        ),
        .testTarget(
            name: "WebAPIsTests",
            dependencies: ["WebAPIs"]
        ),
    ]
)
