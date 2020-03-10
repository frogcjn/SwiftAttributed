//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

// MARK: - Attributed Modifier

public protocol AttributedModifier {
    associatedtype Content : Attributed
    func attributedString(content: Content) -> AttributedString
}


public extension Attributed {
    func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

#if canImport(SwiftUI)
import struct SwiftUI.ModifiedContent
#else
public struct ModifiedContent<Content, Modifier> {
    public var  content: Content
    public var modifier: Modifier
}
#endif

extension ModifiedContent : Attributed where Modifier : AttributedModifier, Modifier.Content == Content {
    public var attributedString : AttributedString {
        modifier.attributedString(content: content)
    }
}
