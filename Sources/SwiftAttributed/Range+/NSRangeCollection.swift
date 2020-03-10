//
//  NSRange+.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

import Foundation

// MARK: - Full Ranged Collection
public extension Collection {
    func    range() -> Range<Index> { startIndex..<endIndex }
}

// MARK: - NS Ranged Collection
public protocol NSRangedCollection : Collection {
    func nsRange() -> NSRange
    
    func nsRange(_: Range<Index>?) -> NSRange
    func   range(ns: NSRange?    ) -> Range<Index>
}

// MARK: - Int Ranged Collection
public extension NSRangedCollection {
    subscript(ns: NSRange) -> SubSequence { self[range(ns: ns)] }

    func intRange() -> Range<Int> { nsRange().intRange }
    func intRange(_ range: Range<Index>?) -> Range<Int> { nsRange(range).intRange }
    func    range(int: Range<Int>?) -> Range<Index> { range(ns: int?.nsRange) }
    subscript(int: Range<Int>) -> SubSequence { self[range(int:int)] }
    subscript<R : RangeExpression>(int r: R) -> SubSequence where R.Bound == Int { self[range(int: r.relative(to: intRange()))] }
}

// MARK: - Int Indexed Collection
public extension NSRangedCollection {
    // SwiftIndex <=> IntIndex
    func     intIndex(_ index: Index)  -> Int   { intRange(index..<index).lowerBound }
    
    // IntIndex <=> IntIndex
    func        index(_ intIndex: Int) -> Index { range(int: intIndex..<intIndex).lowerBound }
    

    // use IntIndex
    var startIntIndex   : Int   { intIndex(startIndex)         }
    var   endIntIndex   : Int   { intIndex(startIndex) + count }
    var      intIndices : [Int] { indices.map(intIndex(_:))    }
    subscript(intIndex: Int) -> Element { self[index(intIndex)] }
}

