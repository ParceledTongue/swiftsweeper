import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(minesweeper_cliTests.allTests),
    ]
}
#endif