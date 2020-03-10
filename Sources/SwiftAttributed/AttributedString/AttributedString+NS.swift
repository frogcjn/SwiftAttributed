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

public typealias AttributeName = AttributedString.Key
public typealias Attribute     = Any
public typealias Attributes    = [AttributeName : Attribute]
public extension AttributedString {
    typealias                      Key = NSAttributedString.Key
    typealias     DocumentAttributeKey = NSAttributedString.DocumentAttributeKey
    typealias DocumentReadingOptionKey = NSAttributedString.DocumentReadingOptionKey
    typealias     TextLayoutSectionKey = NSAttributedString.TextLayoutSectionKey
    
    typealias             DocumentType = NSAttributedString.DocumentType
    
    typealias    TextEffectStyle = NSAttributedString.TextEffectStyle
    
    typealias EnumerationOptions = NSAttributedString.EnumerationOptions
    #if os(macOS)
    typealias     DrawingOptions = NSString.DrawingOptions
    #else
    typealias     DrawingOptions = NSStringDrawingOptions
    #endif
}

// MARK: - Creating an AttributedString

public extension AttributedString {
    
    init() {
        _ns = NSMutableAttributedString()
    }
    
    init(_ string: String) {
        _ns = NSMutableAttributedString(string: string)
    }
    
    
    init(_ string: String, attributes: Attributes) {
        _ns = NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    init(_ attrString: NSAttributedString) {
        _ns = attrString.mutableCopy() as! NSMutableAttributedString
    }
}

// MARK: - Attributed <-> Data

public extension AttributedString {
    init(data: Data, options: [DocumentReadingOptionKey : Any] = [:], documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) throws {
        _ns = try NSMutableAttributedString(data: data, options: options, documentAttributes: dict)
    }
    
   
    init(url: URL, options: [DocumentReadingOptionKey : Any] = [:], documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) throws {
        _ns = try NSMutableAttributedString(url: url, options: options, documentAttributes: dict)
    }

    mutating func read(from data: Data, options opts: [DocumentReadingOptionKey : Any] = [:], documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) throws {
        try update {
            #if !os(macOS)
            try $0.read(from: data, options: opts, documentAttributes: dict)
            #else
            try $0.read(from: data, options: opts, documentAttributes: dict, error: ())
            #endif
        }
    }
    
    mutating func read(from url: URL, options opts: [DocumentReadingOptionKey : Any] = [:], documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) throws {
        try update {
            #if !os(macOS)
            try $0.read(from: url, options: opts, documentAttributes: dict)
            #else
            try $0.read(from: url, options: opts, documentAttributes: dict, error: ())
            #endif
        }
    }
    
    func data(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) throws -> Data {
        try _ns.data(from: nsRange(range), documentAttributes: dict)
    }
    
    func fileWrapper(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) throws -> FileWrapper {
        try _ns.fileWrapper(from: nsRange(range), documentAttributes: dict)
    }
}

// MARK: - Attributed <-> Attachment

public extension AttributedString {
    #if !os(watchOS)
    init(attachment: NSTextAttachment) {
        _ns = NSMutableAttributedString(attachment: attachment)
    }
    #endif

}

// MARK: - Retrieving Attributes
public extension AttributedString {

    // attributes(at:)
    func getAttributes(at index: Index, in rangeLimit: Range<Index>? = nil) -> (attributes: Attributes, effectiveRange: Range<Index>)  {
        
        var effectiveRange = NSRange()
        let attributes: Attributes
        if let rangeLimit = rangeLimit {
            attributes = _ns.attributes(at: index, longestEffectiveRange: &effectiveRange, in: rangeLimit.nsRange)
        } else {
            attributes = _ns.attributes(at: index, effectiveRange: &effectiveRange)
        }
        return (attributes, effectiveRange.intRange)
    }
    
    // attribute(_:at:)
    func getAttribute(_ attrName: AttributeName, at index: Index, in rangeLimit: Range<Index>? = nil) -> (attribute: Attribute?, effectiveRange: Range<Index>) {

        var effectiveRange = NSRange()
        let attribute: Attribute?
        if let rangeLimit = rangeLimit {
            attribute = _ns.attribute(attrName, at: index, longestEffectiveRange: &effectiveRange, in: rangeLimit.nsRange)
        } else {
            attribute = _ns.attribute(attrName, at: index, effectiveRange: &effectiveRange)
        }
        return (attribute, effectiveRange.intRange)
    }
    
    // enumerateAttributes(in:options:using:)
    func enumerateAttributes(in enumerationRange: Range<Index>? = nil, options opts: EnumerationOptions = [], using continuing: (Attributes, Range<Index>) -> Bool) {
        _ns.enumerateAttributes(in: nsRange(enumerationRange), options: opts) { (attributes: Attributes, range: NSRange, objBool: UnsafeMutablePointer<ObjCBool>) in
            let bool = continuing(attributes, self.range(ns:range))
            objBool.pointee = ObjCBool(!bool)
        }
    }
    
    // enumerateAttribute(_:in:options:using:)
    func enumerateAttribute(_ attrName: AttributeName, in enumerationRange: Range<Index>? = nil, options opts: EnumerationOptions = [], using continuing: (Attribute?, Range<Index>) -> Bool) {
        _ns.enumerateAttribute(attrName, in: nsRange(enumerationRange), options: opts) { (attribute: Attribute?, range: NSRange, objBool: UnsafeMutablePointer<ObjCBool>) in
            let bool = continuing(attribute, self.range(ns:range))
            objBool.pointee = ObjCBool(!bool)
        }
    }
}

// MARK: - Changing attributes

public extension AttributedString {
    
    // setAttribute(s)
    mutating func setAttribute(_ name: AttributeName, value: Attribute, in range: Range<Int>? = nil) {
        setAttributes([name: value], in: range)
    }

    mutating func setAttributes(_ attrs: Attributes, in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.setAttributes(attrs, range: range) }
    }
    
    // addAttribute(s)
    mutating func addAttribute(_ name: AttributeName, value: Attribute, in range: Range<Index>? = nil) {
        let range = nsRange(range)
        update { $0.addAttribute(name, value: value, range: range) }
    }
    
    mutating func addAttributes(_ attrs: Attributes, in range: Range<Index>? = nil) {
        let range = nsRange(range)
        update { $0.addAttributes(attrs, range: range) }
    }
    
    // removeAttribute(s)
    mutating func removeAttributes<S : Sequence>(_ names: S, in range: Range<Index>? = nil) where S.Element == AttributeName {
        let range = nsRange(range)
        update { ns in names.forEach { ns.removeAttribute($0, range: range) } }
    }
    
    mutating func removeAttribute(_ name: AttributeName, in range: Range<Index>? = nil) {
        let range = nsRange(range)
        update { $0.removeAttribute(name, range: range) }
    }
    
    // fixAttributes
    mutating func fixAttributes(in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.fixAttributes(in: range) }
    }
    
    // text alignment
    mutating func setAlignment(_ textAlignment:  NSTextAlignment, in range: Range<Index>? = nil) {
        #if !os(macOS)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        addAttribute(.paragraphStyle, value: paragraphStyle, in: range)
        #else
        let range = nsRange(range)
        update { $0.setAlignment(textAlignment, range: range) }
        #endif
    }
    
    func beginEditing() {
        _ns.beginEditing()
    }
    
    func endEditing() {
        _ns.endEditing()
    }
}

// MARK: - Drawing the String

extension AttributedString {
    func draw(at point: CGPoint) { _ns.draw(at: point) }
    func draw(in rect: CGRect) { _ns.draw(in: rect) }
    func draw(with rect: CGRect, options: DrawingOptions = [], context: NSStringDrawingContext?) {
        _ns.draw(with: rect, options: options, context: context)
    }

}

// MARK: - Getting Metrics for the String

extension AttributedString {
    func size() -> CGSize { _ns.size() }
    
    func boundingRect(with size: CGSize, options: DrawingOptions = [], context: NSStringDrawingContext?) -> CGRect {
        _ns.boundingRect(with: size, options: options, context: context)
    }
    
    func containsAttachments(in range: NSRange) -> Bool {
        _ns.containsAttachments(in: range)
    }

}
