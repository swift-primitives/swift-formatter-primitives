public import Formatter_Protocol

public struct Format<Input, Output, Failure: Swift.Error> {

    public var _format: (Input) throws(Failure) -> Output

    @inlinable
    public init(_ format: @escaping (Input) throws(Failure) -> Output) {
        self._format = format
    }
}

extension Format {

    @inlinable
    public init<F: Formatter.`Protocol`>(_ source: F)
    where F.Input == Input, F.Output == Output, F.Failure == Failure {
        self.init { value throws(Failure) in try source.format(value) }
    }
}

extension Format: Formatter.`Protocol` {

    @inlinable
    public func format(_ value: Input) throws(Failure) -> Output {
        try _format(value)
    }
}
