// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "web-apis",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .watchOS(.v10),
    .tvOS(.v17),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "WebAPIs",
      targets: ["WebAPIs"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/gnorium/web-types", branch: "main"),
    .package(url: "https://github.com/gnorium/embedded-swift-utilities", branch: "main"),
    .package(url: "https://github.com/gnorium/web-builders", branch: "main"),
  ],
  targets: [
    .target(
      name: "WebAPIs",
      dependencies: [
        .product(name: "WebTypes", package: "web-types"),
        .product(name: "EmbeddedSwiftUtilities", package: "embedded-swift-utilities"),
        .product(name: "HTMLBuilder", package: "web-builders"),
      ],
      swiftSettings: [
        .enableExperimentalFeature("Embedded", .when(platforms: [.wasi])),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("StrictConcurrency"),
        .enableExperimentalFeature("Extern", .when(platforms: [.wasi])),
        .define("CLIENT", .when(platforms: [.wasi])),
        .define("SERVER", .when(platforms: [.macOS, .linux, .windows])),
      ]
    ),
    .testTarget(
      name: "WebAPIsTests",
      dependencies: ["WebAPIs"]
    ),
  ]
)
