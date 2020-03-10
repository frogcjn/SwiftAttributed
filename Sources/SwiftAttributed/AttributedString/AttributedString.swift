//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct AttributedString {
    let _ns: NSMutableAttributedString
    
    private var _refCounter = RefConter()
    private class RefConter {}
}


public extension AttributedString {
    mutating func update(_ closure: ((NSMutableAttributedString) throws -> Void)? = nil) rethrows {
        // copy the reference only if necessary
        if !isKnownUniquelyReferenced(&_refCounter) {
            self = .init(_ns: nsMutable)
        }
        
        try closure?(_ns)
    }
}
