import XCTest

import minesweeper_cliTests

var tests = [XCTestCaseEntry]()
tests += minesweeper_cliTests.allTests()
XCTMain(tests)