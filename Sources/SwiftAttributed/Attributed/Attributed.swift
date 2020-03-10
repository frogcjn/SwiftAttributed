//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

// MARK: - Attributed

public protocol Attributed {
    var attributedString: AttributedString { get }
}

// MARK: - Attributed Quick Access

import Foundation
public extension Attributed {
    var string : String {
        attributedString._ns.string
    }
    
    var ns: NSAttributedString {
        attributedString._ns.copy() as! NSAttributedString
    }
    
    var nsMutable: NSMutableAttributedString {
        attributedString._ns.mutableCopy() as! NSMutableAttributedString
    }
}

// MARK: - Attributed + String/NSAttributedString/AttributedString

extension String : Attributed {
    public var attributedString : AttributedString { AttributedString(self) }
}

extension NSAttributedString : Attributed {
    public var attributedString : AttributedString { AttributedString(self) }
}

extension AttributedString : Attributed {
    public var attributedString : AttributedString { self }
}
