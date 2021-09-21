//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/14/21.
//

import Foundation

#if arch(x86_64) || arch(arm64)

@frozen public struct TaggedPointer<T> {
    @usableFromInline var pointer: UnsafePointer<T>
    
    public init(_ other: UnsafePointer<T>) {
        self.pointer = other
    }
    
    public init(_ other: UnsafePointer<T>, data: UInt16) {
        self.pointer = other
        self.data = data
    }
    
    @inlinable
    public func deallocate() {
        pointer.deallocate()
    }
    
    public var data: UInt16 {
        @inlinable
        get {
            UInt16(UInt(bitPattern: pointer) >> 48)
        }
        @inlinable
        set {
            let mask = ~(UInt(1) << 48)
            let pattern = (UInt(bitPattern: pointer) & mask) | (UInt(newValue) << 48)
            pointer = UnsafePointer<T>(bitPattern: pattern).unsafelyUnwrapped
        }
    }
    
    @inlinable
    public var pointee: T {
        let pointer = (Int(bitPattern: pointer) << 16) >> 16
        return *UnsafePointer<T>(bitPattern: pointer).unsafelyUnwrapped
    }
}

#endif
