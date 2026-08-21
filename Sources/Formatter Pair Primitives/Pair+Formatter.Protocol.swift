extension Pair: Formatter.`Protocol`
where
    First: Formatter.`Protocol`,
    Second: Formatter.`Protocol`
{

    public typealias Input = Pair<First.Input, Second.Input>

    public typealias Output = Pair<First.Output, Second.Output>

    public typealias Failure = Either<First.Failure, Second.Failure>

    @inlinable
    public func format(
        _ value: Pair<First.Input, Second.Input>
    )
        throws(Either<First.Failure, Second.Failure>) -> Pair<First.Output, Second.Output>
    {
        let o0: First.Output
        do throws(First.Failure) { o0 = try first.format(value.first) } catch { throw .left(error) }
        let o1: Second.Output
        do throws(Second.Failure) { o1 = try second.format(value.second) } catch {
            throw .right(error)
        }
        return Pair<First.Output, Second.Output>(o0, o1)
    }
}
