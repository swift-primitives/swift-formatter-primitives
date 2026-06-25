# Formatter Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The abstract formatting-capability layer for Swift — a `Formatter.Protocol` for value-to-value transformations whose audience is humans, with typed throws and zero platform dependencies.

---

## Quick Start

`Formatter.Protocol` is the contract for value-to-value transformations aimed at human-facing presentation: locale-dependent rendering, lossy projection, return-complete output. A formatter takes an `Input` and returns formatted `Output` (generic, so non-`String` formatters compose without ceremony), failing through a typed `Failure` — `Never` for the common infallible case.

```swift
import Formatter_Protocol

// A concrete formatter is one type per format x value pair.
struct PercentFormatter: Formatter.`Protocol` {
    typealias Input = Double
    typealias Output = String
    typealias Failure = Never

    func format(_ value: Double) -> String {
        "\(Int(value * 100))%"
    }
}

let formatted = PercentFormatter().format(0.42)  // "42%"
```

Conform a type to `Formattable` to give it a canonical formatter, then format any value of that type through `.formatted()`:

```swift
import Formattable

extension Double: Formattable {
    static var formatter: PercentFormatter { PercentFormatter() }
}

let ratio = 0.42.formatted()  // "42%"
```

`Formattable` is independent of `Parseable`, `Serializable`, and `Codable` — a value can be formatted for humans (lossy presentation) without being recoverable for machines, and vice versa.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-formatter-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two roots in one package: `Formatter` is the capability namespace, `Formattable` is the value-side attachment. They are mutually independent but conventionally co-located as the formatter ecosystem's contract pair. The package decomposes into per-concept targets so consumers import only what they extend.

| Product | When to import |
|---------|----------------|
| `Formatter Primitive` | Extending the `Formatter` namespace alone — zero transitive cost. |
| `Formatter Protocol` | Writing a concrete `Formatter.\`Protocol\`` conformer. |
| `Formattable` | Attaching a canonical formatter to a value type and calling `.formatted()`. |
| `Format` | Using the closure-backed `Format<Input, Output, Failure>` witness or its type-eraser. |
| `Formatter Pair Primitives` | Composing two formatters into a binary `Pair` formatter. |
| `Formatter Primitives` (umbrella) | The union of the above — convenient for prototyping and tests. |
| `Formatter Primitives Test Support` | Re-exports the umbrella for downstream test targets. |

The `Format` witness wraps a `format` closure and doubles as a type-eraser for storing heterogeneous formatters; import the `Format` product directly to use it. The `Pair` integration conforms `Pair<First, Second>` to `Formatter.\`Protocol\`` when both arms are formatters, routing distinct inputs to each arm and unifying failures through `Either`.

Two external dependencies (`swift-either-primitives`, `swift-pair-primitives`), no Foundation.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
