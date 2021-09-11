//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/7/21.
//

import Foundation

@inlinable
@inline(__always)
/// Performs a bit cast from the provided *value-type* to a different *value-type*.
/// - Returns: Provided *value-type* reinterpreted as another *value-type* instance.
public func bitCast<T, V>(_ value: V) -> T {
    precondition(!object_isClass(V.self), "bitCast(_:) is not supported for reference types. Use referenceReinterpretationCast(_:) instead.")
    precondition(strideof(V.self) == strideof(T.self), "Different lenghts. Use reinterpretationCast(_:) instead.")
    return unsafeBitCast(value, to: T.self)
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *value-type* to a different *value-type*.
/// Allows reinterpretation to a type witn smaller lenght (members that do not fit in the destination type will be ignored).
/// In Ounckeched will have the same effect as uncheckedReinterpretationCast(_:)
/// - Returns: Provided *value-type* reinterpreted as another *value-type* instance.
public func reinterpretationCast<T, V>(_ value: V) -> T {
    precondition(strideof(V.self) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    var result = value
    return *pointer(to: &result)
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *value-type* to a different *value-type*.
/// Completely ignores types lenghts (members that do not fit in the source type lenght will have junk bits).
/// This is the most unsafe cast ever! Use only when you a sure that destination object's adress can hold `value` lenght (e.g. in a contiguous storage).
/// - Returns: Provided *value-type* reinterpreted as another *value-type* instance.
public func uncheckedReinterpretationCast<T, V>(_ value: V) -> T {
    var result = value
    return *pointer(to: &result)
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *reference-type* to a different *reference-type*.
/// Allows reinterpretation to a type with smaller lenght (members that do not fit in the destination type will be ignored).
/// In Ounckeched will have the same effect as uncheckedReferenceReinterpretationCast(_:)
/// - Returns: Provided *reference-type* reinterpreted as another *reference-type* instance.
func referenceReinterpretationCast<T: AnyObject>(_ value: AnyObject) -> T {
    precondition(T.self != NSObject.self && type(of: value) != NSObject.self, "Cannot cast between NSObject classes, only native Swift types are supported. For NSObjects use Obj-C runtime instead.")
    precondition(strideof(value) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    let ptr: Ref<T> = pointer(to: value)
    return *ptr
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *reference-type* to a different *reference-type*.
/// Completely ignores types lenghts (members that do not fit in the source type lenght will have junk bits).
/// This is the most unsafe cast ever! Use only when you a sure that destination object's adress can hold `value` lenght (e.g. in a contiguous storage).
/// - Returns: Provided *reference-type* reinterpreted as another *reference-type* instance.
func uncheckedReferenceReinterpretationCast<T: AnyObject>(_ value: AnyObject) -> T {
    precondition(T.self != NSObject.self && type(of: value) != NSObject.self, "Cannot cast between NSObject classes, only native Swift types are supported. For NSObjects use Obj-C runtime instead.")
    let ptr: Ref<T> = pointer(to: value)
    return *ptr
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *reference-type* to a different *value-type*.
/// Allows reinterpretation to a type with smaller lenght (members that do not fit in the destination type will be ignored).
/// In Ounckeched will have the same effect as uncheckedReferenceToValueReinterpretationCast(_:)
/// - Returns: Provided *reference-type* reinterpreted as another *value-type* instance.
func referenceToValueReinterpretationCast<T>(_ value: AnyObject) -> T {
    precondition(T.self != NSObject.self && type(of: value) != NSObject.self, "Cannot cast between NSObject classes, only native Swift types are supported. For NSObjects use Obj-C runtime instead.")
    precondition(strideof(value) >= strideof(T.self), "Different lenghts. This will cause undefined behavior.")
    let headerOffset = strideof((Word, Word).self)
    let membersStart: Ref<T> = pointer(to: value) + headerOffset
    return *membersStart
}

@inlinable
@inline(__always)
/// Performs a reinterpratetion cast from the provided *reference-type* to a different *value-type*.
/// Completely ignores types lenghts (members that do not fit in the source type lenght will have junk bits).
/// This is the most unsafe cast ever! Use only when you a sure that destination object's adress can hold `value` lenght (e.g. in a contiguous storage).
/// - Returns: Provided *reference-type* reinterpreted as another *value-type* instance.
func uncheckedReferenceToValueReinterpretationCast<T>(_ value: AnyObject) -> T {
    precondition(T.self != NSObject.self && type(of: value) != NSObject.self, "Cannot cast between NSObject classes, only native Swift types are supported. For NSObjects use Obj-C runtime instead.")
    let headerOffset = strideof((Word, Word).self)
    let membersStart: Ref<T> = pointer(to: value) + headerOffset
    return *membersStart
}
