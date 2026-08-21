public import Formatter_Primitive

extension Formatter {

    public protocol `Protocol`<Input, Output, Failure> {

        associatedtype Input

        associatedtype Output

        associatedtype Failure: Swift.Error

        func format(_ value: Input) throws(Failure) -> Output
    }
}
