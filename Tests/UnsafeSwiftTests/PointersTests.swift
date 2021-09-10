import XCTest
@testable import UnsafeSwift

final class PointersTests: XCTestCase {
    
    func testPointerValueType() throws {
        var a = 42
        let p1: Ref<Int> = pointer(to: &a)
        let p2: Ref<Int> = pointer(to: &a)
        XCTAssertEqual(p1, p2)
        XCTAssertEqual(*p1, *p2)
    }
    
    class SwiftClass: Equatable {
        let value = Int.random(in: Int.min..<Int.max)
        static func == (lhs: PointersTests.SwiftClass, rhs: PointersTests.SwiftClass) -> Bool {
            lhs.value == rhs.value
        }
    }
    
    func testPointerReferenceType() throws {
        let a = SwiftClass()
        let p1: Ref<SwiftClass> = pointer(to: a)
        let p2: Ref<SwiftClass> = pointer(to: a)
        XCTAssertEqual(p1, p2)
        XCTAssertEqual(*p1, *p2)
    }
}
