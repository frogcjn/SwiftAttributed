//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

import Foundation

extension AttributedString : Codable {
    public init(from decoder: Decoder) throws {
        try self.init(data: Data(from: decoder), documentAttributes: nil)
    }
    
    public func encode(to encoder: Encoder) throws {
        try data().encode(to: encoder)
    }
}

extension AttributedString : Equatable {
    public static func == (lhs: AttributedString, rhs: AttributedString) -> Bool {
        lhs._ns == rhs._ns
    }
        
}
extension AttributedString : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_ns)
    }
}

extension AttributedString : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension AttributedString : CVarArg {
    public var _cVarArgEncoding: [Int] {
        _ns._cVarArgEncoding
    }
}

extension AttributedString : BidirectionalCollection {}
extension AttributedString : RangeReplaceableCollection {}

// MARK: - NSAttributedString + Collection
    
public extension AttributedString {
    typealias       Index = Int
    typealias     Element = AttributedString
    typealias SubSequence = AttributedString
    
    var                   startIndex: Int { 0          }
    var                     endIndex: Int { _ns.length }
    func      index(after  i: Int) -> Int { i + 1      }
    func      index(before i: Int) -> Int { i - 1      } // BidirectionalCollection
    
    subscript(position: Index   ) -> AttributedString { self[position...position] }
    
    // Extracting a Substring
    subscript(  bounds: Range<Int>) -> AttributedString {
        get { subrange(from: bounds) }
        set { replaceSubrange(bounds, with: newValue) }
    }
}

// MARK: - Collection

public extension AttributedString {
    // replaceCharacters
    mutating func replaceSubrange(_ subrange: Range<Int>, with newElements: AttributedString) {
        update { $0.replaceCharacters(in: subrange.nsRange, with: newElements._ns) }
    }
    
    // deleteCharacters
    mutating func removeSubrange(_ subrange: Range<Int>) {
        update { $0.deleteCharacters(in: subrange.nsRange) }
    }
        
    mutating func insert(_ newElement: AttributedString, at i: Index) {
        insert(contentsOf: newElement, at: i)
    }
    
    mutating func insert(_ newElements: String, at i: Index) {
        insert(contentsOf: newElements.attributedString, at: i)
    }
    
    mutating func insert(contentsOf newElements: AttributedString, at i: Index) {
        update { $0.insert(newElements._ns, at: i) }
    }
    
    // mutating func append<S>(contentsOf newElements: S) where S : Sequence, Self.Element == S.Element
    mutating func append(contentsOf newElements: AttributedString) {
        update { $0.append(newElements._ns) }
    }
}



public extension AttributedString {
    
    func subrange(from range: Range<Int>? = nil) -> AttributedString {
        .init(_ns.attributedSubstring(from: nsRange(range)))
    }
    
    mutating func append(_ attrString: AttributedString) {
        append(contentsOf: attrString)
    }
    
    mutating func append(_ string: String) {
        append(contentsOf: string.attributedString)
    }
    
    mutating func set(_ attrString: AttributedString) {
        update { $0.setAttributedString(attrString._ns) }
    }
    
    mutating func set(_ string: String) {
        update { $0.setAttributedString(NSAttributedString(string: string)) }
    }
}

extension Array where Element == AttributedString {
    public func joined(separator: AttributedString = AttributedString()) -> AttributedString {
        var result = AttributedString()
        
        dropLast().forEach {
            result.append($0)
            result.append(separator)
        }
        
        if let last = self.last {
            result.append(last)
        }
        
        return result
    }
}


/*extension AttributedString : CustomDebugStringConvertible {
    public var debugDescription: String {
        _ns.debugDescription
    }
}

extension AttributedString : CustomStringConvertible {
    public var description: String {
        _ns.description
    }
}

extension AttributedString : CustomReflectable {
    public var customMirror: Mirror {
        
    }
}*/

/*
 ✅ CVarArg
 
 ✅ Decodable
 ✅ Encodable
 
 ✅Equatable
 ✅Hashable
 ❌Comparable
 
 ✅ BidirectionalCollection
 ✅ RangeReplaceableCollection
 
 ❌ CustomDebugStringConvertible
 ❌ CustomStringConvertible
 ❌ CustomReflectable
 ❌ ExpressibleByStringLiteral
 
 ❌ CKRecordValueProtocol
 ❌ StringProtocol
 ❌ MLDataValueConvertible
 ❌ MLIdentifier
 ❌ TextOutputStream
 ❌ TextOutputStreamable
 */
