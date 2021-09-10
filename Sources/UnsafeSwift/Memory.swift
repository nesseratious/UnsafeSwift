//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/7/21.
//

import Foundation

@inlinable
@inline(__always)
public func sizeofAllocation<T>(_ value: inout T) -> Int {
    return malloc_size(&value)
}

@inlinable
@inline(__always)
public func sizeofAllocation<T: AnyObject>(_ value: T) -> Int {
    return malloc_size(pointer(to: value))
}

@inlinable
@inline(__always)
public func sizeof<T>(_ value: T) -> Int {
    return MemoryLayout<T>.size(ofValue: value)
}

@inlinable
@inline(__always)
public func sizeof<T>(_ value: T.Type) -> Int {
    return MemoryLayout<T>.size
}

@inlinable
@inline(__always)
public func strideof<T>(_ value: T) -> Int {
    return MemoryLayout<T>.stride(ofValue: value)
}

@inlinable
@inline(__always)
public func strideof<T>(_ value: T.Type) -> Int {
    return MemoryLayout<T>.stride
}

@inlinable
@inline(__always)
public func sizeof(_ value: AnyObject) -> Int {
    return strideof(value) &- sizeof((Word, Word).self)
}

@inlinable
@inline(__always)
public func sizeof<T: AnyObject>(_ value: T.Type) -> Int {
    return class_getInstanceSize(T.self) &- sizeof((Word, Word).self)
}

@inlinable
@inline(__always)
public func strideof(_ value: AnyObject) -> Int {
    return class_getInstanceSize(type(of: value))
}

@inlinable
@inline(__always)
public func strideof<T: AnyObject>(_ value: T.Type) -> Int {
    return class_getInstanceSize(T.self)
}
