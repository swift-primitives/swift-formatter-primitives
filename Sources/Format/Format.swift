//
//  Format.swift
//  swift-formatter-primitives
//
//  Top-level closure-backed formatter witness.
//

public import Formatter_Protocol

/// A closure-backed formatter — the canonical witness for
/// ``Formatter/Protocol``.
///
/// `Format` stores a `format` closure and exposes it as the method required
/// by ``Formatter/Protocol``. The witness lives at the top level of the
/// module so callers can reference `Format<I, O, F>` without paying a
/// generic-binding tax that would apply if it were nested inside a generic
/// outer type (per the agent-witness-attachable pattern).
///
/// ## Shape
///
/// `Format` mirrors the formatter protocol's value-in / value-out signature:
///
/// ```swift
/// func format(_ value: Input) throws(Failure) -> Output
/// ```
///
/// Unlike parser / serializer witnesses, `Format` does NOT take `inout Input`
/// or borrow self — formatters are pure value-to-value transformations.
///
/// ## Example
///
/// ```swift
/// let percent = Format<Double, String, Never> { value in
///     "\(Int(value * 100))%"
/// }
/// let text = percent.format(0.42)  // "42%"
/// ```
///
/// ## Type Erasure
///
/// `Format` doubles as a type-eraser: wrap any concrete formatter into a
/// `Format` value to store heterogeneous formatters in a collection or to
/// erase structural type information at an API boundary.
///
/// ```swift
/// let typeErased = Format(CurrencyFormatter())
/// ```
public struct Format<Input, Output, Failure: Swift.Error> {
    /// The stored format closure.
    ///
    /// The leading underscore signals an implementation hatch.
    public var _format: (Input) throws(Failure) -> Output

    /// Creates a formatter witness from a format closure.
    ///
    /// - Parameter format: Converts an `Input` to formatted `Output`.
    @inlinable
    public init(_ format: @escaping (Input) throws(Failure) -> Output) {
        self._format = format
    }
}

// MARK: - Type Erasure

extension Format {
    /// Wraps any concrete formatter as a `Format` witness.
    ///
    /// - Parameter source: A formatter whose `Input` / `Output` / `Failure`
    ///   match this witness.
    @inlinable
    public init<F: Formatter.`Protocol`>(_ source: F)
    where F.Input == Input, F.Output == Output, F.Failure == Failure {
        self.init { value throws(Failure) in try source.format(value) }
    }
}

// MARK: - Formatter.Protocol Conformance

extension Format: Formatter.`Protocol` {

    /// Formats `value` by invoking the stored closure.
    @inlinable
    public func format(_ value: Input) throws(Failure) -> Output {
        try _format(value)
    }
}
