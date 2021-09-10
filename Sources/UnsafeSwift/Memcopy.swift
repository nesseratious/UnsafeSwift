//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/10/21.
//

import Foundation

@inlinable
@inline(__always)
public func memoryCopy(from source: UnsafeRawPointer, to destination: UnsafeMutableRawPointer, lenght: Int = sizeof(Word.self)) {
    destination.copyMemory(from: source, byteCount: lenght)
}
