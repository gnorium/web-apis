# WebAPIs, as used in [gnorium.com](https://gnorium.com)

Swift implementations of Web APIs for Swift WebAssembly environments, enabling JavaScript-like Web API usage in browser-based Swift applications.

## Overview

WebAPIs provides Swift types and interfaces that mirror standard Web APIs, allowing you to write Swift code for WebAssembly with familiar Web platform conventions.

Built for **Swift SDK for WebAssembly**, enabling browser-based Swift applications with direct access to DOM, CSS, Storage, and other Web APIs.

## Features

- **DOM-like APIs**: Document manipulation interfaces
- **CSS APIs**: `CSSStyleDeclaration`, color schemes, property setters
- **Console API**: `console.log()` equivalents for WebAssembly debugging
- **Event APIs**: `CustomEvent` and event handling
- **Dataset APIs**: HTML5 dataset attribute handling

## Installation

### Swift Package Manager

Add WebAPIs to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gnorium/web-apis", branch: "main")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "WebAPIs", package: "web-apis")
    ]
)
```

## Usage

```swift
import WebAPIs

// Use Web APIs in Swift WebAssembly
let console = Console()
console.log("Hello from Swift WebAssembly!")

// Work with CSS properties
let style = CSSStyleDeclaration()
style.setProperty("color", value: "red")
```

## Requirements

- Swift 6.2+
- Swift SDK for WebAssembly

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details

## Contributing

Contributions welcome! Please open an issue or submit a pull request.

## Related Packages

- [design-tokens](https://github.com/gnorium/design-tokens) - Universal design tokens based on Apple HIG
- [embedded-swift-utilities](https://github.com/gnorium/embedded-swift-utilities) - Utility functions for Embedded Swift environments
- [markdown-utilities](https://github.com/gnorium/markdown-utilities) - Markdown rendering with media attribution support
- [web-administrator](https://github.com/gnorium/web-administrator) - Web administration panel for applications
- [web-builders](https://github.com/gnorium/web-builders) - HTML, CSS, JS, and SVG DSL builders
- [web-components](https://github.com/gnorium/web-components) - Reusable UI components for web applications
- [web-formats](https://github.com/gnorium/web-formats) - Structured data format builders
- [web-security](https://github.com/gnorium/web-security) - Portable security utilities for web applications
- [web-types](https://github.com/gnorium/web-types) - Shared web types and design tokens
