//
//  Formatter.Protocol.swift
//  swift-formatter-primitives
//
//  Core Formatter protocol definition.
//

public import Formatter_Primitive

extension Formatter {
    /// A type that converts a value to formatted output.
    ///
    /// Formatters are value-to-value transformations — they take an `Input`
    /// and return formatted `Output`, typically a `String` (but generic over
    /// `Output` so non-String formatters compose without ceremony).
    ///
    /// ## Return-Complete Signature
    ///
    /// Unlike `Serializer.Protocol` which appends to a buffer, `Formatter.Protocol`
    /// returns the complete output. Formatters produce a value per call rather
    /// than streaming into a buffer. This matches the typical formatter use
    /// case: take a value, get the formatted representation back.
    ///
    /// ## No Body / No Builder
    ///
    /// Unlike `Parser.Protocol` and `Serializer.Protocol`, `Formatter.Protocol`
    /// has no declarative composition via `Body`/`Builder`. Formatters are
    /// typically leaf types — one per format × value pair, parameterized by
    /// configuration values from the `Format` namespace. Compositional
    /// formatting (`.formatted(.percent).uppercased()`) lives at the call
    /// site via method extensions, not at the protocol layer.
    ///
    /// ## Typed Throws
    ///
    /// Formatters use typed throws with a `Failure` associated type. Use
    /// `Never` for infallible formatters (the common case). Specific
    /// formatters that can fail — locale parse failures, precision overflow,
    /// encoding rejection — declare a real failure type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct CurrencyFormatter: Formatter.`Protocol` {
    ///     typealias Input = Double
    ///     typealias Output = String
    ///     typealias Failure = Never
    ///
    ///     func format(_ value: Double) -> String {
    ///         "$\(String(format: "%.2f", value))"
    ///     }
    /// }
    ///
    /// 42.5.formatted(CurrencyFormatter())  // "$42.50"
    /// ```
    public protocol `Protocol`<Input, Output, Failure> {
        /// The input value type accepted by this formatter.
        associatedtype Input

        /// The output type produced by formatting.
        associatedtype Output

        /// The error type this formatter can throw.
        ///
        /// Use `Never` for infallible formatters.
        associatedtype Failure: Swift.Error

        /// Converts a value to its formatted representation.
        ///
        /// - Parameter value: The value to format.
        /// - Returns: The formatted output.
        /// - Throws: `Failure` if formatting fails.
        func format(_ value: Input) throws(Failure) -> Output
    }
}

// Typed throws with `Failure == Never` is treated as non-throwing at the
// call site automatically — no convenience overload required. See SE-0413.
