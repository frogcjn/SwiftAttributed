//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

#if os(macOS)
import AppKit
public extension AttributedString {
    typealias SpellingState = NSAttributedString.SpellingState
    
    static var textTypes: [String] {
        NSAttributedString.textTypes
    }
    
    static var textUnfilteredTypes: [String] {
        NSAttributedString.textUnfilteredTypes
    }
    
    // create from data
    
    init?(docFormat data: Data, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(docFormat: data, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }
    
    init?(html data: Data, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(html: data, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }
    
    init?(html data: Data, baseURL base: URL, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(html: data, baseURL: base, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }
    
    init?(html data: Data, options: [DocumentReadingOptionKey : Any] = [:], documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(html: data, options: options, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }

    init?(rtf data: Data, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(rtf: data, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }

    init?(rtfd data: Data, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(rtfd: data, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }

    init?(rtfdFileWrapper wrapper: FileWrapper, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>?) {
        guard let _ns = NSMutableAttributedString(rtfdFileWrapper: wrapper, documentAttributes: dict) else { return nil }
        self._ns = _ns
    }
    
    // Generating Data
    
    func rtf(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) -> Data? {
        _ns.rtf(from: nsRange(range), documentAttributes: dict)
    }
    
    func rtfd(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) -> Data? {
        _ns.rtfd(from: nsRange(range), documentAttributes: dict)
    }
    
    func rtfdFileWrapper(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) -> FileWrapper? {
        _ns.rtfdFileWrapper(from: nsRange(range), documentAttributes: dict)
    }
    
    func docFormat(from range: Range<Int>? = nil, documentAttributes dict: [DocumentAttributeKey : Any] = [:]) -> Data? {
        _ns.docFormat(from: nsRange(range), documentAttributes: dict)
    }
    
    // get attributess
    
    func fontAttributes(in range: Range<Int>) -> Attributes {
        _ns.fontAttributes(in: range.nsRange)
    }
    
    func rulerAttributes(in range: Range<Int>) -> Attributes {
        _ns.rulerAttributes(in: range.nsRange)
    }
    
    // set attributes
    
    mutating func applyFontTraits(_ traitMask: NSFontTraitMask, in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.applyFontTraits(traitMask, range: range) }
    }
    
    mutating func setBaseWritingDirection(_ writingDirection: NSWritingDirection, in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.setBaseWritingDirection(writingDirection, range: range) }
    }
    
    mutating func subscriptRange(_ range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.subscriptRange(range) }
    }
    
    mutating func superscriptRange(_ range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.superscriptRange(range) }
    }
    
    mutating func unscriptRange(_ range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.unscriptRange(range) }
    }
    
    mutating func updateAttachments(fromPath path: String) {
        update { $0.updateAttachments(fromPath: path) }
    }
    
    // fix
    
    mutating func fixAttachmentAttribute(in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.fixAttachmentAttribute(in: range) }
    }

    mutating func fixFontAttribute(in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.fixFontAttribute(in: range) }
    }

    mutating func fixParagraphStyleAttribute(in range: Range<Int>? = nil) {
        let range = nsRange(range)
        update { $0.fixParagraphStyleAttribute(in: range) }
    }
    
    
    // Calculating Linguistic Units
    
    func doubleClick(at location: Int) -> Range<Int> {
        _ns.doubleClick(at: location).intRange
    }
    
    func lineBreak(before location: Int, within aRange: Range<Int>) -> Int {
        _ns.lineBreak(before: location, within: aRange.nsRange)
    }
    
    func lineBreakByHyphenating(before location: Int, within aRange: Range<Int>) -> Int {
        _ns.lineBreakByHyphenating(before: location, within: aRange.nsRange)
    }
    
    func nextWord(from location: Int, forward isForward: Bool) -> Int {
        _ns.nextWord(from: location, forward: isForward)
    }
    
    // Calculating Ranges
    
    func itemNumber(in list: NSTextList, at location: Int) -> Int {
        _ns.itemNumber(in: list, at: location)
    }
    
    func range(of block: NSTextBlock, at location: Int) -> Range<Int> {
        _ns.range(of: block, at: location).intRange
    }
    
    func range(of list: NSTextList, at location: Int) -> Range<Int> {
        _ns.range(of: list, at: location).intRange
    }
    
    func range(of table: NSTextTable, at location: Int) -> Range<Int> {
        _ns.range(of: table, at: location).intRange
    }
}
#endif
