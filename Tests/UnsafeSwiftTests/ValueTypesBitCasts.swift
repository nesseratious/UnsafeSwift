import XCTest
@testable import UnsafeSwift

final class ValueTypesBitCasts: XCTestCase {
    
    struct A {
        let x: Int
        let y: Int
    }
    
    struct B {
        let x: Int
        let y: Int
    }
    
    func testBitcastPrimitiveValueType() throws {
        let a = 42
        var b = 0
        b = bitCast(a)
        XCTAssertEqual(b, a)
    }
    
    func testBitcastStructValueType() throws {
        let a = A(x: 10, y: 20)
        var b = B(x: 0, y: 0)
        b = bitCast(a)
        XCTAssertEqual(b.x, a.x)
        XCTAssertEqual(b.y, a.y)
    }
    
    func testBitcastInternalValueType() throws {
        let a = CGSize(width: 10, height: 20)
        var b = SIMD2<Double>(0, 0)
        b = bitCast(a)
        XCTAssertEqual(b.x, a.width)
        XCTAssertEqual(b.y, a.height)
    }
    
}
