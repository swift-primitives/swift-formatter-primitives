//
//  Pair+Formatter.Protocol.swift
//  swift-formatter-primitives
//
//  Pair<First, Second> as a binary formatter combinator,
//  reusing the binary product primitive from swift-pair-primitives.
//

/// Conforms ``Pair`` to ``Formatter/Protocol`` via typed routing.
///
/// When both arms of a `Pair` are themselves formatters, the pair becomes a
/// formatter whose `Input` is a `Pair` of the arms' inputs and whose `Output`
/// is a `Pair` of the arms' outputs. Each arm runs on its routed input
/// independently. Failures are unified via ``Either`` — a thrown `First.Failure`
/// surfaces as `.left`; a thrown `Second.Failure` surfaces as `.right`.
///
/// ## Routing
///
/// Unlike ``Parser/Protocol`` Pair composition (which shares a single mutable
/// input across both arms sequentially), formatter Pair composition routes
/// distinct values to each arm. The input shape `Pair<First.Input, Second.Input>`
/// makes this routing structural rather than positional.
///
/// ## Example
///
/// ```swift
/// let intToString = Format<Int, String, Never> { "\($0)" }
/// let doubleToString = Format<Double, String, Never> { "\($0)" }
/// let pair = Pair(intToString, doubleToString)
/// let formatted = pair.format(Pair(42, 3.14))
/// // formatted.first == "42", formatted.second == "3.14"
/// ```
extension Pair: Formatter.`Protocol`
where
    First: Formatter.`Protocol`,
    Second: Formatter.`Protocol`
{
    /// A `Pair` of each arm's input, routed independently to the matching arm.
    public typealias Input = Pair<First.Input, Second.Input>

    /// A `Pair` of each arm's output, in arm order.
    public typealias Output = Pair<First.Output, Second.Output>

    /// An `Either` unifying the two arms' failures: `.left` for the first, `.right` for the second.
    public typealias Failure = Either<First.Failure, Second.Failure>

    /// Formats each arm's routed input, pairing the outputs and unifying failures via `Either`.
    @inlinable
    public func format(
        _ value: Pair<First.Input, Second.Input>
    )
        throws(Either<First.Failure, Second.Failure>) -> Pair<First.Output, Second.Output>
    {
        let o0: First.Output
        do { o0 = try first.format(value.first) } catch { throw .left(error) }
        let o1: Second.Output
        do { o1 = try second.format(value.second) } catch { throw .right(error) }
        return Pair<First.Output, Second.Output>(o0, o1)
    }
}
