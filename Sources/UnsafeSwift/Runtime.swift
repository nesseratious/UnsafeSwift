//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/8/21.
//

import Foundation

public enum Runtime {
    
    @inlinable
    @inline(__always)
    /// Returns a pointer to the provided *reference-type* object's ISA
    /// - Parameter object: *reference-type* object
    /// - Returns: Pointer to the object's ISA
    public static func getISA(object: AnyObject) -> UInt {
        let ptr: UnsafeMutablePointer<UInt> = pointer(to: object)
        return *ptr
    }
    
    @inlinable
    @inline(__always)
    /// Returns a pointer to the provided *reference-type* object's compound reference count field (strong + unowned + flags)
    /// - Parameter object: *reference-type* object
    /// - Returns: Pointer to the object's compound reference count field (strong + unowned + flags)
    public static func getCompoundRefField(object: AnyObject) -> UInt {
        let ptr: UnsafeMutablePointer<UInt> = pointer(to: object)
        return *(ptr + strideof(Word.self))
    }
    
    @inlinable
    @inline(__always)
    /// Returns true if the provided *reference-type* object is using a side table (e.g. was referenced by a weak reference OR in case of one ref count overflow)
    /// - Parameter object: *reference-type* object
    /// - Returns: True if object is using a side-table.
    public static func isUsingSidetable(object: AnyObject) -> Bool {
        let refField = getCompoundRefField(object: object)
        let word = Word(pattern: refField)
        return word.bytes.0.bits[0] == .zero
    }
    
    static func getSidetable(object: AnyObject) -> SizeTable? {
        guard isUsingSidetable(object: object) else { return nil }
        let ptr: UnsafeMutablePointer<UInt> = pointer(to: object) + 8
        return *UnsafeMutableRawPointer(ptr)
    }
    
    struct SizeTable {
        let ref0: Word
        let ref1: HWord
        let ref2: HWord
        let ref3: HWord
    }
}
