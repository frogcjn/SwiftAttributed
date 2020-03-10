import XCTest
@testable import SwiftAttributed

final class SwiftAttributedTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftAttributed().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
