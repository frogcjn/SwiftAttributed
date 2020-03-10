//
//  NSRange+.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

import Foundation

extension AttributedString : NSRangedCollection {}

public extension AttributedString {
    func nsRange() -> NSRange { range().nsRange }
    
    // InrRange <=> SwiftRange
    func nsRange(_ range:   Range<Index>?) -> NSRange        { range? .nsRange ?? nsRange() }
    func   range(     ns: NSRange?       ) ->   Range<Index> {    ns?.intRange ??   range() }
}
