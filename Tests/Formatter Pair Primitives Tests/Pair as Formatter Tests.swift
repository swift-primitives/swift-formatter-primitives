import Formatter_Pair_Primitives
import Formatter_Primitives_Test_Support
import Testing

private struct DecimalFormatter: Formatter.`Protocol` {
}

extension DecimalFormatter {
    typealias Input = Int
    typealias Output = String
    typealias Failure = Never

    func format(_ value: Int) -> String {
        "\(value)"
    }
}

private struct AlwaysFailing<Input, Output, Failure: Swift.Error>: Formatter.`Protocol` {
    let error: Failure
}

extension AlwaysFailing {
    func format(_ value: Input) throws(Failure) -> Output {
        throw error
    }
}

private struct FirstFailure: Swift.Error, Equatable {
    let tag: String
}

private struct SecondFailure: Swift.Error, Equatable {
    let tag: String
}

@Suite
struct `Pair as Formatter Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Pair as Formatter Tests`.Unit {

    @Test
    func `both arms succeed: output is a Pair of each arm's output`() throws(Either<Never, Never>) {
        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let formatted = try pair.format(Pair(42, 7))
        #expect(formatted.first == "42")
        #expect(formatted.second == "7")
    }

    @Test
    func `arms receive distinct routed inputs (no input sharing)`() throws(Either<Never, Never>) {
        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let formatted = try pair.format(Pair(1, 2))
        #expect(formatted.first == "1")
        #expect(formatted.second == "2")
    }

    @Test
    func `inferred typealiases compose: Output is Pair, Failure is Either`() throws(Either<
        Never, Never
    >) {

        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let input: Pair<Int, Int> = Pair(10, 20)
        let output: Pair<String, String> = try pair.format(input)
        #expect(output.first == "10")
        #expect(output.second == "20")
    }
}

extension `Pair as Formatter Tests`.`Edge Case` {

    @Test
    func `first arm throws: caught as Either left`() {
        let firstError = FirstFailure(tag: "first-failed")
        let pair = Pair(
            AlwaysFailing<Int, String, FirstFailure>(error: firstError),
            DecimalFormatter()
        )

        do throws(Either<FirstFailure, Never>) {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected first arm to throw")
        } catch {

            switch error {
            case .left(let inner):
                #expect(inner == firstError)

            case .right:
                Issue.record("Expected .left, got .right")
            }
        }
    }

    @Test
    func `second arm throws: caught as Either right`() {
        let secondError = SecondFailure(tag: "second-failed")
        let pair = Pair(
            DecimalFormatter(),
            AlwaysFailing<Int, String, SecondFailure>(error: secondError)
        )

        do throws(Either<Never, SecondFailure>) {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected second arm to throw")
        } catch {

            switch error {
            case .left:
                Issue.record("Expected .right, got .left")

            case .right(let inner):
                #expect(inner == secondError)
            }
        }
    }

    @Test
    func `both arms can throw: first failure short-circuits via Either left`() {
        let firstError = FirstFailure(tag: "first-wins")
        let secondError = SecondFailure(tag: "second-never-runs")
        let pair = Pair(
            AlwaysFailing<Int, String, FirstFailure>(error: firstError),
            AlwaysFailing<Int, String, SecondFailure>(error: secondError)
        )

        do throws(Either<FirstFailure, SecondFailure>) {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected first arm to throw")
        } catch {

            switch error {
            case .left(let inner):
                #expect(inner == firstError)

            case .right:
                Issue.record("Expected .left (first arm short-circuits), got .right")
            }
        }
        _ = secondError
    }
}
