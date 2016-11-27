import XCTest
@testable import QuadTree

class QuadTreeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(QuadTree().text, "Hello, World!")
    }


    static var allTests : [(String, (QuadTreeTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
