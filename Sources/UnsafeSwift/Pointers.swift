//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/7/21.
//

import Foundation

public typealias Ref<T> = UnsafeMutablePointer<T>

@inlinable
@inline(__always)
/// Returns a pointer to the *value-type* object
/// - Parameter obj: Object with *value-type* semantics
/// - Returns: Pointer to the object
///
public func pointer<T>(to obj: UnsafeRawPointer) -> Ref<T> {
    return UnsafeMutableRawPointer(mutating: obj).assumingMemoryBound(to: T.self)
}

@inlinable
@inline(__always)
/// Returns a pointer to the *reference-type* object
/// - Parameter obj: Object with *reference-type* semantics
/// - Returns: Pointer to the object
///
public func pointer<T>(to obj: AnyObject) -> Ref<T> {
    return Unmanaged.passUnretained(obj).toOpaque().assumingMemoryBound(to: T.self)
}

public protocol RefProtocol {
    func dereference<T>() -> T
}

public protocol VoidRef: RefProtocol {
    
}

public protocol TypedRef: RefProtocol {

}

extension UnsafeRawPointer: VoidRef {
    public func dereference<T>() -> T {
        load(as: T.self)
    }
}

extension UnsafeMutableRawPointer: VoidRef {
    public func dereference<T>() -> T {
        load(as: T.self)
    }
}

prefix operator *

prefix operator &&

@inlinable
@inline(__always)
public prefix func &&<T>(lvalue: inout T) -> UnsafeMutablePointer<T> {
    return pointer(to: &lvalue)
}

@inlinable
@inline(__always)
public prefix func *<T>(lvalue: UnsafeRawPointer) -> T {
    return lvalue.dereference()
}

@inlinable
@inline(__always)
public prefix func *<T>(lvalue: UnsafeMutableRawPointer) -> T {
    return lvalue.dereference()
}

@inlinable
@inline(__always)
public prefix func *<T>(lvalue: UnsafePointer<T>) -> T {
    precondition(T.self != NSObject.self, "Cannot dereference a NSObject class pointer, only native Swift classes/actors/structs/enums are supported. For NSObjects use Obj-C runtime instead.")
    return lvalue.pointee
}

@inlinable
@inline(__always)
public prefix func *<T>(lvalue: UnsafeMutablePointer<T>) -> T {
    precondition(T.self != NSObject.self, "Cannot dereference a NSObject class pointer, only native Swift classes/actors/structs/enums are supported. For NSObjects use Obj-C runtime instead.")
    return lvalue.pointee
}
