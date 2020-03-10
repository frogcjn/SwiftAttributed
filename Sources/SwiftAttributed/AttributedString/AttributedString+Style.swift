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

public enum Style {
    case fontWeight(Font.Weight, defaultFont: Font)
    case bold(defaultFont: Font)
    case italic(defaultFont: Font)
    case `subscript`(defaultFont: Font)
    case superscript(defaultFont: Font)

    case font(Font)
    case foregroundColor(Color)
    case backgroundColor(Color)
    case strikethrough(Bool, color: Color? = nil)
    case underline(Bool, color: Color? = nil)
    case kerning(CGFloat)
    case tracking(CGFloat)
    case baselineOffset(CGFloat)
    
    case allowsTightening(Bool) // allowsDefaultTighteningForTruncation
    // case minimumScaleFactor(CGFloat)
    case truncationMode(NSLineBreakMode)
    // case lineLimit(let line: Int)
    case lineSpacing(CGFloat)
    case multilineTextAlignment(NSTextAlignment)
    case flipsForRightToLeftLayoutDirection(Bool)
}

public extension AttributedString {
    
    mutating func addStyle(_ style: Style, in range: Range<Int>? = nil) {
        let range = range ?? self.range()
        var current = range.lowerBound
        while current < range.upperBound {
            let (attributes, affectedRange) = getAttributes(at: current, in: range)
            let styledAttributes = attributes.addingStyle(style)
            addAttributes(styledAttributes, in: affectedRange)
            current = affectedRange.upperBound
        }
    }
    
    mutating func setFontWeight(_ weight: Font.Weight, defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.fontWeight(weight, defaultFont: defaultFont), in: range)
    }
    
    mutating func addBold(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.bold(defaultFont: defaultFont), in: range)
    }
    
    mutating func addItalic(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.italic(defaultFont: defaultFont), in: range)
    }
    
    mutating func addSubscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.subscript(defaultFont: defaultFont), in: range)
    }
    
    mutating func addSuperscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.superscript(defaultFont: defaultFont), in: range)
    }
    
    mutating func setFont(_ font: Font, in range: Range<Int>? = nil) {
        addStyle(.font(font), in: range)
    }
    
    mutating func setForegroundColor(_ color: Color, in range: Range<Int>? = nil) {
        addStyle(.foregroundColor(color), in: range)
    }
    
    mutating func setBackgroundColor(_ color: Color, in range: Range<Int>? = nil) {
        addStyle(.backgroundColor(color), in: range)
    }

    mutating func setStrikethrough(_ enabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) {
        addStyle(.strikethrough(enabled, color: color), in: range)
    }
    
    mutating func setUnderline(_ enabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) {
        addStyle(.underline(enabled, color: color), in: range)
    }
    
    mutating func setKerning(_ kerning: CGFloat, in range: Range<Int>? = nil) {
        addStyle(.kerning(kerning), in: range)
    }
    
    mutating func setTracking(_ tracking: CGFloat, in range: Range<Int>? = nil) {
        addStyle(.tracking(tracking), in: range)
    }
    
    mutating func setBaselineOffset(_ baselineOffset: CGFloat, in range: Range<Int>? = nil) {
        addStyle(.baselineOffset(baselineOffset), in: range)
    }
    
    mutating func setAllowsTightening(_ enabled: Bool, in range: Range<Int>? = nil) {
        addStyle(.allowsTightening(enabled), in: range)
    }
    
    mutating func setTruncationMode(_ mode: NSLineBreakMode, in range: Range<Int>? = nil) {
        addStyle(.truncationMode(mode), in: range)
    }
    
    mutating func setLineSpacing(_ spacing: CGFloat, in range: Range<Int>? = nil) {
        addStyle(.lineSpacing(spacing), in: range)
    }
    
    mutating func setMultilineTextAlignment(_ alignment: NSTextAlignment, in range: Range<Int>? = nil) {
        addStyle(.multilineTextAlignment(alignment), in: range)
    }
    
    mutating func setFlipsForRightToLeftLayoutDirection(_ enabled: Bool, in range: Range<Int>? = nil) {
        addStyle(.flipsForRightToLeftLayoutDirection(enabled), in: range)
    }
}

// Attributes + Styles

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    func addingStyle(_ style: Style) -> Self {
        switch style {
        case .font           (let font          ): return [.font           : font          ]
        case .foregroundColor(let color         ): return [.foregroundColor: color         ]
        case .backgroundColor(let color         ): return [.backgroundColor: color         ]
        case .kerning        (let kerning       ): return [.kern           : kerning       ]
        case .tracking       (let tracking      ): return [.kern           : tracking      ]
        case .baselineOffset (let baselineOffset): return [.baselineOffset : baselineOffset]
        case .strikethrough(let enabled, let color):
            return [
                .strikethroughStyle: (enabled ? .single : []) as NSUnderlineStyle,
                .strikethroughColor: color ?? NSNull()
            ]
        case .underline(let enabled, let color):
            return [
                .underlineStyle: (enabled ? .single : []) as NSUnderlineStyle,
                .underlineColor: color ?? NSNull()
            ]
        case .fontWeight,
             .bold,
             .italic,
             .superscript,
             .subscript:
            let font = self[.font] as! Font?
            switch style {
            case .fontWeight(let weight, let defaultFont): return [.font: (font ?? defaultFont).weight(weight)]
            case .bold       (let defaultFont): return [.font: (font ?? defaultFont).bold()        ]
            case .italic     (let defaultFont): return [.font: (font ?? defaultFont).italic()      ]
            case .superscript(let defaultFont), .subscript(let defaultFont):
                    let superscriptFontSize = (font ?? defaultFont).pointSize * 5/6
                    let value: Int
                    if case .superscript = style { value = SuperscriptValue.superscript } else { value = SuperscriptValue.subscript }
                    return [
                               .font: (font ?? defaultFont).withSize(superscriptFontSize),
                        .superscript: value
                    ]
                default: fatalError()
            }
        case .allowsTightening,
             .truncationMode,
             .lineSpacing,
             .multilineTextAlignment,
             .flipsForRightToLeftLayoutDirection:
            let unmutableParagraphStyle = self[.paragraphStyle] as! NSParagraphStyle? ?? .init()
            let paragraphStyle = unmutableParagraphStyle.mutableCopy() as! NSMutableParagraphStyle
            switch style {
            case .allowsTightening                  (let enabled  ): paragraphStyle.allowsDefaultTighteningForTruncation = enabled
            case .truncationMode                    (let mode     ): paragraphStyle.lineBreakMode                        = mode
            case .lineSpacing                       (let spacing  ): paragraphStyle.lineSpacing                          = spacing
            case .multilineTextAlignment            (let alignment): paragraphStyle.alignment                            = alignment
            case .flipsForRightToLeftLayoutDirection(let enabled  ): paragraphStyle.baseWritingDirection                 = enabled ? .rightToLeft : .natural
            default: fatalError()
            }
            return [.paragraphStyle: paragraphStyle.copy()]
        }
    }
}
