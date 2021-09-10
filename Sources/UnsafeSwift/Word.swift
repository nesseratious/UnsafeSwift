//
//  File.swift
//  File
//
//  Created by Denis Esie on 9/8/21.
//

/// Represents one word for the current platform
public struct Word: WordProtocol {
    
#if arch(arm64) || arch(x86_64)
    @usableFromInline let bytes: (Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte)
#elseif arch(i386)
    @usableFromInline let bytes: (Byte, Byte, Byte, Byte)
#endif
    
    public init(pattern: UInt) {
#if arch(arm64) || arch(x86_64)
        bytes.7 = Byte(pattern: UInt8((pattern >> 56) & 255))
        bytes.6 = Byte(pattern: UInt8((pattern >> 48) & 255))
        bytes.5 = Byte(pattern: UInt8((pattern >> 40) & 255))
        bytes.4 = Byte(pattern: UInt8((pattern >> 32) & 255))
#endif
        bytes.3 = Byte(pattern: UInt8((pattern >> 24) & 255))
        bytes.2 = Byte(pattern: UInt8((pattern >> 16) & 255))
        bytes.1 = Byte(pattern: UInt8((pattern >> 8) & 255))
        bytes.0 = Byte(pattern: UInt8((pattern >> 0) & 255))
    }
    
    public var description: String {
#if arch(arm64) || arch(x86_64)
        "\(bytes.0) \(bytes.1) \(bytes.2) \(bytes.3) \(bytes.4) \(bytes.5) \(bytes.6) \(bytes.7)"
#elseif arch(i386)
        "\(bytes.0) \(bytes.1) \(bytes.2) \(bytes.3)"
#endif
    }
    
    public static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.description == rhs.description
    }
}

/// Represents half-word for the current platform
public struct HWord: WordProtocol {
    
#if arch(arm64) || arch(x86_64)
    @usableFromInline let bytes: (Byte, Byte, Byte, Byte)
#elseif arch(i386)
    @usableFromInline let bytes: (Byte, Byte)
#endif
    
    public init(pattern: UInt32) {
#if arch(arm64) || arch(x86_64)
        bytes.3 = Byte(pattern: UInt8((pattern >> 24) & 255))
        bytes.2 = Byte(pattern: UInt8((pattern >> 16) & 255))
#endif
        bytes.1 = Byte(pattern: UInt8((pattern >> 8) & 255))
        bytes.0 = Byte(pattern: UInt8((pattern >> 0) & 255))
    }
    
    public var description: String {
#if arch(arm64) || arch(x86_64)
        "\(bytes.0) \(bytes.1) \(bytes.2) \(bytes.3)"
#elseif arch(i386)
        "\(bytes.0) \(bytes.1)"
#endif
    }
    
    public static func == (lhs: HWord, rhs: HWord) -> Bool {
        return lhs.bytes == rhs.bytes
    }
}

extension HWord: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt32) {
        self.init(pattern: value)
    }
}

/// Represents a single byte
public struct Byte {
    let pattern: UInt8
    
    init(pattern: UInt8) {
        self.pattern = pattern
    }
    
    @usableFromInline
    var bits: [Bit] {
        var byte = pattern
        var bits = [Bit](repeating: .zero, count: 8)
        for i in 0..<8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }
            byte >>= 1
        }
        return bits
    }
}

extension Byte: CustomStringConvertible, Equatable {
    public var description: String {
        bits.map { $0.description }.joined()
    }
    
    public static func == (lhs: Byte, rhs: Byte) -> Bool {
        return lhs.pattern == rhs.pattern
    }
}

extension Byte: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt8) {
        self.init(pattern: value)
    }
}

/// Represents a single bit
public enum Bit: UInt8, CustomStringConvertible {
    case zero = 0, one = 1
    
    public var description: String {
        String(rawValue)
    }
}

#if arch(arm64) || arch(x86_64)
public typealias WordType = UInt64
#elseif arch(i386)
public typealias WordType = UInt32
#else
#error("Unsupported ISA")
#endif

public protocol WordProtocol: CustomStringConvertible, Equatable {
    
}

extension WordProtocol {
    var pattern: UInt {
        return UInt(description.replacingOccurrences(of: " ", with: ""), radix: 2)!
    }
}
