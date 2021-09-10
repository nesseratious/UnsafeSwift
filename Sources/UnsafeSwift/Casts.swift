//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/7/21.
//

import Foundation

@inlinable
@inline(__always)
public func bitCast<T, V>(_ value: V) -> T {
    precondition(!object_isClass(V.self), "bitCast(_:) is not supported for reference types. Use referenceReinterpretationCast(_:) instead.")
    precondition(strideof(V.self) == strideof(T.self), "Different lenghts. Use reinterpretationCast instead.")
    return unsafeBitCast(value, to: T.self)
}

@inlinable
@inline(__always)
public func reinterpretationCast<T, V>(_ value: V) -> T {
    precondition(T.self != NSObject.self && V.self != NSObject.self, "Cannot cast between NSObject classes, only native Swift classes/actors/structs/enums are supported. For NSObjects use Obj-C runtime instead.")
    precondition(strideof(V.self) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    var result = value
    return *pointer(to: &result)
}

@inline(__always)
func referenceReinterpretationCast<T: AnyObject>(_ value: AnyObject) -> T {
    precondition(strideof(value) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    let ptr: Ref<T> = pointer(to: value)
    return *ptr
}

@inline(__always)
func referenceToValueReinterpretationCast<T>(_ value: AnyObject) -> T {
    precondition(strideof(value) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    let headerOffset = strideof((Word, Word).self)
    let membersStart: Ref<T> = pointer(to: value) + headerOffset
    return *membersStart
}
