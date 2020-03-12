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
    case bold(Bool, defaultFont: Font)
    case italic(Bool, defaultFont: Font)
    case `subscript`(Bool, defaultFont: Font)
    case superscript(Bool, defaultFont: Font)

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
    
    mutating func addBold(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.bold(true, defaultFont: defaultFont), in: range)
    }
    
    mutating func addItalic(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.italic(true, defaultFont: defaultFont), in: range)
    }
    
    mutating func addSubscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.subscript(true, defaultFont: defaultFont), in: range)
    }
    
    mutating func addSuperscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.superscript(true, defaultFont: defaultFont), in: range)
    }
    
    mutating func removeBold(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.bold(false, defaultFont: defaultFont), in: range)
    }
    
    mutating func removeItalic(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.italic(false, defaultFont: defaultFont), in: range)
    }
    
    mutating func removeSubscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.subscript(false, defaultFont: defaultFont), in: range)
    }
    
    mutating func removeSuperscript(defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.superscript(false, defaultFont: defaultFont), in: range)
    }
    
    mutating func setFontWeight(_ weight: Font.Weight, defaultFont: Font = systemDefaultFont, in range: Range<Int>? = nil) {
        addStyle(.fontWeight(weight, defaultFont: defaultFont), in: range)
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

    mutating func setStrikethrough(_ isEnabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) {
        addStyle(.strikethrough(isEnabled, color: color), in: range)
    }
    
    mutating func setUnderline(_ isEnabled: Bool, color: Color? = nil, in range: Range<Int>? = nil) {
        addStyle(.underline(isEnabled, color: color), in: range)
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
    
    mutating func setAllowsTightening(_ isEnabled: Bool, in range: Range<Int>? = nil) {
        addStyle(.allowsTightening(isEnabled), in: range)
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
    
    mutating func setFlipsForRightToLeftLayoutDirection(_ isEnabled: Bool, in range: Range<Int>? = nil) {
        addStyle(.flipsForRightToLeftLayoutDirection(isEnabled), in: range)
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
        case .strikethrough(let isEnabled, let color):
            return [
                .strikethroughStyle: (isEnabled ? .single : []) as NSUnderlineStyle,
                .strikethroughColor: color ?? NSNull()
            ]
        case .underline(let isEnabled, let color):
            return [
                .underlineStyle: (isEnabled ? .single : []) as NSUnderlineStyle,
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
            case .bold       (let isEnabled, let defaultFont):
                return [.font: (font ?? defaultFont).bold(isEnabled)        ]
            case .italic     (let isEnabled, let defaultFont):
                return [.font: (font ?? defaultFont).italic(isEnabled)      ]
            case .superscript(let isEnabled, let defaultFont), .subscript(let isEnabled, let defaultFont):
                let font = font ?? defaultFont
                if isEnabled {
                    let superscriptFontSize = font.pointSize * 5/6
                    let value: Int
                    if case .superscript = style { value = SuperscriptValue.superscript } else { value = SuperscriptValue.subscript }
                    return [
                               .font: font.withSize(superscriptFontSize),
                        .superscript: value
                    ]
                } else {
                    return [
                               .font: font,
                        .superscript: 0
                    ]
                }
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
            case .allowsTightening                  (let isEnabled): paragraphStyle.allowsDefaultTighteningForTruncation = isEnabled
            case .truncationMode                    (let mode     ): paragraphStyle.lineBreakMode                        = mode
            case .lineSpacing                       (let spacing  ): paragraphStyle.lineSpacing                          = spacing
            case .multilineTextAlignment            (let alignment): paragraphStyle.alignment                            = alignment
            case .flipsForRightToLeftLayoutDirection(let isEnabled): paragraphStyle.baseWritingDirection                 = isEnabled ? .rightToLeft : .natural
            default: fatalError()
            }
            return [.paragraphStyle: paragraphStyle.copy()]
        }
    }
}
