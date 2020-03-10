//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - setAttributes

fileprivate struct SetAttributesModifier<Content : Attributed>: AttributedModifier {
    let attrs: Attributes
    let range: Range<Int>?
    
    func attributedString(content: Content) -> AttributedString {
        var attrString = content.attributedString
        attrString.setAttributes(attrs, in: range)
        return attrString
    }
}

public extension Attributed {
    func setAttributes(_ attrs: Attributes, in range: Range<Int>? = nil) -> some Attributed {
        modifier(SetAttributesModifier(attrs: attrs, range: range))
    }
}

// MARK: - addAttributes
fileprivate struct AddAttributesModifier<Content : Attributed>: AttributedModifier {
    let attrs: Attributes
    let range: Range<Int>?
    
    func attributedString(content: Content) -> AttributedString {
        var attrString = content.attributedString
        attrString.addAttributes(attrs, in: range)
        return attrString
    }
}
    
public extension Attributed {
    func attributes(_ attrs: Attributes, in range: Range<Int>? = nil) -> some Attributed {
        modifier(AddAttributesModifier(attrs: attrs, range: range))
    }
}

// MARK: - removeAttributes

fileprivate struct RemoveAttributesModifier<Content : Attributed, S: Sequence>: AttributedModifier where S.Element == AttributeName {
    let names: S
    let range: Range<Int>?
    
    func attributedString(content: Content) -> AttributedString {
        var attrString = content.attributedString
        attrString.removeAttributes(names, in: range)
        return attrString
    }
}
    
public extension Attributed {
    func removeAttributes<S : Sequence>(_ names: S, in range: Range<Int>? = nil) -> some Attributed where S.Element == AttributeName {
        modifier(RemoveAttributesModifier(names: names, range: range))
    }
}

// MARK: - setAlignment

fileprivate struct SetAlignmentAttributesModifier<Content : Attributed>: AttributedModifier {
    let alignment: NSTextAlignment
    let range: Range<Int>?
    
    func attributedString(content: Content) -> AttributedString {
        var attrString = content.attributedString
        attrString.setAlignment(alignment, in: range)
        return attrString
    }
}
    
public extension Attributed {
    func setAlignment(_ alignment: NSTextAlignment, in range: Range<Int>? = nil) -> some Attributed {
        modifier(SetAlignmentAttributesModifier(alignment: alignment, range: range))
    }
}

// MARK: - fixAttributes
fileprivate struct FixAttributesModifier<Content : Attributed>: AttributedModifier {
    let range: Range<Int>?
    
    func attributedString(content: Content) -> AttributedString {
        var attrString = content.attributedString
        attrString.fixAttributes(in: range)
        return attrString
    }
}
   

public extension Attributed {
    func fixAttributes(range: Range<Int>? = nil) -> some Attributed {
        modifier(FixAttributesModifier(range: range))
    }
}

// MARK: - style
fileprivate struct StyleModifier<Content : Attributed> : AttributedModifier {
    let       style: Style
    let       range: Range<Int>?
    
    init(style: Style, range: Range<Int>? = nil) {
        self.style = style
        self.range = range
    }
    
    func attributedString(content: Content) -> AttributedString {
        var attributed = content.attributedString
        attributed.addStyle(style, in: range)
        return attributed
    }
}

public extension Attributed {
    func style(_ style: Style, in range: Range<Int>? = nil) -> some Attributed {
        modifier(StyleModifier(style: style, range: range))
    }
}

#if !os(macOS)
public let systemDefaultFont = Font.preferredFont(forTextStyle: .body)
#else
public let systemDefaultFont = Font.systemFont(ofSize: Font.systemFontSize)
#endif

public extension Attributed {
    func fontWeight(_ weight: Font.Weight, defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) -> some Attributed {
        modifier(StyleModifier(style: .fontWeight(weight, defaultFont: defaultFont), range: range))
    }
    
    func bold(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .bold(defaultFont: defaultFont), range: range))
    }
    
    func italic(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .italic(defaultFont: defaultFont), range: range))
    }
    
    func `subscript`(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .subscript(defaultFont: defaultFont), range: range))
    }
    
    func superscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .superscript(defaultFont: defaultFont), range: range))
    }
    
    func font(_ font: Font, in range: Range<Int>? = nil) -> some Attributed {
        modifier(StyleModifier(style: .font(font), range: range))
    }
    
    func foregroundColor(_ color: Color, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .foregroundColor(color), range: range))
    }
    
    func backgroundColor(_ color: Color, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .backgroundColor(color), range: range))
    }

    func strikethrough(_ enabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .strikethrough(enabled, color: color), range: range))
    }
    
    func underline(_ enabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .underline(enabled, color: color), range: range))
    }
    
    func kerning(_ kerning: CGFloat, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .kerning(kerning), range: range))
    }
    
    func tracking(_ tracking: CGFloat, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .tracking(tracking), range: range))
    }
    
    func baselineOffset(_ baselineOffset: CGFloat, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .baselineOffset(baselineOffset), range: range))
    }
    
    func allowsTightening(_ enabled: Bool, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .allowsTightening(enabled), range: range))
    }
    
    func truncationMode(_ mode: NSLineBreakMode, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .truncationMode(mode), range: range))
    }
    
    func lineSpacing(_ spacing: CGFloat, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .lineSpacing(spacing), range: range))
    }
    
    func multilineTextAlignment(_ alignment: NSTextAlignment, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .multilineTextAlignment(alignment), range: range))
    }
    
    func flipsForRightToLeftLayoutDirection(_ enabled: Bool, in range: Range<Int>? = nil) -> some Attributed  {
        modifier(StyleModifier(style: .flipsForRightToLeftLayoutDirection(enabled), range: range))
    }
}
