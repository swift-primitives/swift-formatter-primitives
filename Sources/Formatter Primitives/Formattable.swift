//
//  Formattable.swift
//  swift-formatter-primitives
//
//  Canonical attachment protocol for formatting.
//

/// A type that has a canonical formatter.
///
/// Conforming types declare their canonical ``Formatter`` and provide a static
/// accessor to obtain it. This enables generic algorithms to discover the
/// formatter for any `Formattable` type.
///
/// `Formattable` is independent of `Parseable`, `Serializable`, and `Codable`
/// — a type may be formatted (lossy presentation for humans) without being
/// parseable (recoverable representation for machines), and vice versa.
///
/// ```swift
/// extension Double: Formattable {
///     static var formatter: Numeric.Decimal.Formatter {
///         .init(notation: .decimal, precision: .significantDigits(15))
///     }
/// }
/// ```
public protocol Formattable {
    /// The canonical formatter type for this value.
    associatedtype Formatter: Formatter_Primitives.Formatter.`Protocol`

    /// The canonical formatter instance.
    static var formatter: Formatter { get }
}

// MARK: - Instance-level format

extension Formattable where Formatter.Input == Self {

    /// Formats this value using the canonical formatter.
    ///
    /// When `Formatter.Failure == Never`, callers omit `try` per SE-0413
    /// typed-throws semantics. The single overload covers both cases.
    ///
    /// - Returns: The formatted output.
    /// - Throws: `Formatter.Failure` if formatting fails.
    @inlinable
    public func formatted() throws(Formatter.Failure) -> Formatter.Output {
        try Self.formatter.format(self)
    }
}
