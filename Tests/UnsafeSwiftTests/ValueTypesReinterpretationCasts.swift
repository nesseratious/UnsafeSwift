import XCTest
@testable import UnsafeSwift

final class ValueTypesReinterpretationCasts: XCTestCase {
    
    struct A {
        let x: Int
        let y: Int
    }
    
    struct B {
        let x: Int
        let y: Int
    }
    
    struct C {
        let x: Int
        let y: Int
        let z: Int
    }
    
    func testReintcastPrimitiveValueType() throws {
        let a = 42
        var b = 0
        b = reinterpretationCast(a)
        XCTAssertEqual(b, a)
    }
    
    func testReintcastBitsValueType() throws {
        let a: UInt64 = 0x10100101
        var b: UInt32 = 0
        b = reinterpretationCast(a)
        XCTAssertEqual(UInt64(b), a)
    }
    
    func testReintcastBoolValueType() throws {
        let a: UInt64 = 1
        var b = false
        b = reinterpretationCast(a)
        XCTAssertEqual(b, true)
    }
    
    func testReintcastBool2ValueType() throws {
        let a: UInt64 = 0
        var b = true
        b = reinterpretationCast(a)
        XCTAssertEqual(b, false)
    }
    
    func testReintcastStructValueType() throws {
        let a = A(x: 10, y: 20)
        var b = B(x: 0, y: 0)
        b = reinterpretationCast(a)
        XCTAssertEqual(b.x, a.x)
        XCTAssertEqual(b.y, a.y)
    }
    
    func testReintcastMisalignedStructValueType() throws {
        let a = C(x: 10, y: 20, z: 30)
        var b = B(x: 0, y: 0)
        b = reinterpretationCast(a)
        XCTAssertEqual(b.x, a.x)
        XCTAssertEqual(b.y, a.y)
    }
    
    func testReintcastInternalValueType() throws {
        let a = CGSize(width: 10, height: 20)
        var b = SIMD2<Double>(0, 0)
        b = bitCast(a)
        XCTAssertEqual(b.x, a.width)
        XCTAssertEqual(b.y, a.height)
    }
    
}
