//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/10/21.
//

import Foundation

#if arch(x86_64)
import _Builtin_intrinsics.intel
#elseif arch (arm64)
import _Builtin_intrinsics.arm
#endif


@inlinable
@inline(__always)
/// Copies bytes from source buffer to destination buffer
/// - Parameters:
///   - source: Source buffer
///   - destination: Destination buffer
///   - lenght: Lenght in bytes
public func memoryCopy32(from source: UnsafeMutableRawPointer, to destination: UnsafeMutableRawPointer, lenght: Int = 32) {
#if arch(x86_64)
    precondition(lenght % 32 == 0);
    var lenght = lenght
    var source = source
    var destination = destination
    while(lenght != 0) {
        _mm256_store_si256(OpaquePointer(destination), source.load(as: __m256i.self))
        source += 32;
        destination += 32;
        lenght &-= 32;
    }
#else
    //TODO: Add native arm64 implementation
    destination.copyMemory(from: source, byteCount: lenght)
#endif
}
