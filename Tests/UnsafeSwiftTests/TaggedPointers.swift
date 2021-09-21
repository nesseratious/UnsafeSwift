import XCTest
@testable import UnsafeSwift

final class TaggedPointersTests: XCTestCase {
    
    func testTaggedPointer() throws {
        var a = 42
        let p1: UnsafeMutablePointer<Int> = pointer(to: &a)
        var tp1 = TaggedPointer(p1)
        tp1.data = 42
        let pointee = tp1.pointee
        XCTAssertEqual(tp1.data, 42)
        XCTAssertEqual(pointee, 42)
        XCTAssertEqual(*tp1, 42)
    }
    
}
