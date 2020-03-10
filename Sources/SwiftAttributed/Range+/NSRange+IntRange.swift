//
//  Range+Index.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

import Foundation

// MARK: - NSRange <=> IntTange

public extension NSRange {
    var intRange: Range<Int> { location ..< location + length }
}

public extension Range where Bound == Int {
    var nsRange: NSRange { NSRange(location: lowerBound, length: upperBound - lowerBound) }
}
