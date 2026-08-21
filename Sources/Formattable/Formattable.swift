public import Formatter_Primitive
public import Formatter_Protocol

public protocol Formattable {

    associatedtype Formatter: Formatter_Primitive.Formatter.`Protocol`

    static var formatter: Formatter { get }
}

extension Formattable where Formatter.Input == Self {

    @inlinable
    public func formatted() throws(Formatter.Failure) -> Formatter.Output {
        try Self.formatter.format(self)
    }
}
