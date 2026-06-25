import Formatter_Pair_Primitives
import Formatter_Primitives_Test_Support
import Testing

// MARK: - Test Fixtures

/// Infallible decimal-rendering fixture: `Int -> String`.
private struct DecimalFormatter: Formatter.`Protocol` {
    typealias Input = Int
    typealias Output = String
    typealias Failure = Never

    func format(_ value: Int) -> String {
        "\(value)"
    }
}

/// Deliberately-failing fixture parameterised by failure type.
private struct AlwaysFailing<Input, Output, Failure: Swift.Error>: Formatter.`Protocol` {
    let error: Failure

    func format(_ value: Input) throws(Failure) -> Output {
        throw error
    }
}

/// Two distinct failure types so `.left` vs `.right` routing is observable.
private struct FirstFailure: Swift.Error, Equatable {
    let tag: String
}

private struct SecondFailure: Swift.Error, Equatable {
    let tag: String
}

// MARK: - Test Suite Structure

/// Parallel-namespace test root for the generic conformance
/// `extension Pair: Formatter.\`Protocol\``.
///
/// Per [SWIFT-TEST-003] the
/// generic-type extension pattern is not available; the suite lives at
/// top level as a non-generic parallel namespace.
@Suite
struct `Pair as Formatter Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

// MARK: - Unit

extension `Pair as Formatter Tests`.Unit {

    @Test
    func `both arms succeed: output is a Pair of each arm's output`() throws(any Swift.Error) {
        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let formatted = try pair.format(Pair(42, 7))
        #expect(formatted.first == "42")
        #expect(formatted.second == "7")
    }

    @Test
    func `arms receive distinct routed inputs (no input sharing)`() throws(any Swift.Error) {
        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let formatted = try pair.format(Pair(1, 2))
        #expect(formatted.first == "1")
        #expect(formatted.second == "2")
    }

    @Test
    func `inferred typealiases compose: Output is Pair, Failure is Either`() throws(any Swift.Error) {
        // Type-level smoke: if Input/Output/Failure typealiases didn't infer,
        // the explicit type annotations on the values below would fail to compile.
        let pair = Pair(DecimalFormatter(), DecimalFormatter())
        let input: Pair<Int, Int> = Pair(10, 20)
        let output: Pair<String, String> = try pair.format(input)
        #expect(output.first == "10")
        #expect(output.second == "20")
    }
}

// MARK: - Edge Case

extension `Pair as Formatter Tests`.`Edge Case` {

    @Test
    func `first arm throws: caught as Either left`() {
        let firstError = FirstFailure(tag: "first-failed")
        let pair = Pair(
            AlwaysFailing<Int, String, FirstFailure>(error: firstError),
            DecimalFormatter()
        )

        do {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected first arm to throw")
        } catch {
            // Typed throws: catch binds `error` as Either<FirstFailure, Never>.
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

        do {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected second arm to throw")
        } catch {
            // Typed throws: catch binds `error` as Either<Never, SecondFailure>.
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

        do {
            _ = try pair.format(Pair(1, 2))
            Issue.record("Expected first arm to throw")
        } catch {
            // Typed throws: catch binds `error` as Either<FirstFailure, SecondFailure>.
            switch error {
            case .left(let inner):
                #expect(inner == firstError)

            case .right:
                Issue.record("Expected .left (first arm short-circuits), got .right")
            }
        }
        _ = secondError  // referenced to document intent; arm never runs
    }
}
