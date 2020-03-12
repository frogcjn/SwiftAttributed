//
//  Font+.swift
//  GREApp
//
//  Created by Cao, Jiannan on 3/10/20.
//  Copyright © 2020 Cao, Jiannan. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias Color          = UIColor
public typealias Font           = UIFont
public typealias FontDescriptor = UIFontDescriptor
public typealias FontFeatureKey = UIFontDescriptor.FeatureKey

public let fontFeatureNameKey   = UIFontDescriptor.FeatureKey.featureIdentifier
public let fontFeatureValueKey  = UIFontDescriptor.FeatureKey.typeIdentifier

extension FontDescriptor.SymbolicTraits {
    static let bold = traitBold
    static let italic = traitItalic

}
#elseif os(macOS)
import AppKit
public typealias Color          = NSColor
public typealias Font           = NSFont
public typealias FontDescriptor = NSFontDescriptor
public typealias FontFeatureKey = NSFontDescriptor.FeatureKey
public let fontFeatureNameKey   = NSFontDescriptor.FeatureKey.typeIdentifier
public let fontFeatureValueKey  = NSFontDescriptor.FeatureKey.selectorIdentifier
#endif

public extension FontDescriptor {
    
    func featureSetting(name: Int, value: Int) -> FontDescriptor {
        let currentFeatureSetting = fontAttributes[.featureSettings] as! [[FontDescriptor.FeatureKey : Any]]
        let featureSetting : [FontFeatureKey : Any] = [
            fontFeatureNameKey: name,
            fontFeatureValueKey: value
        ]
        return addingAttributes([.featureSettings: currentFeatureSetting + [featureSetting]])
    }
    
    func setFeatureSettings(_ featureSettings: [(name: Int, value: Int)]) -> FontDescriptor {
        let featureSettings : [[FontDescriptor.FeatureKey : Any]] = featureSettings.map { [
            fontFeatureNameKey: $0.name,
            fontFeatureValueKey: $0.value
            ] }
        return addingAttributes([.featureSettings: featureSettings])
    }
    
    func setSymbolicTraits(_ traits: SymbolicTraits) -> FontDescriptor {
        #if os(macOS)
        return withSymbolicTraits(traits)
        #else
        return withSymbolicTraits(traits) ?? self
        #endif
    }
    
    func addSymbolicTraits(_ traits: SymbolicTraits) -> FontDescriptor {
        setSymbolicTraits(symbolicTraits.union(traits))
    }
    
    func removeSymbolicTraits(_ traits: SymbolicTraits) -> FontDescriptor {
        setSymbolicTraits(symbolicTraits.subtracting(traits))
    }
    
    func symbolicTraitsContains(_ traits: SymbolicTraits) -> Bool {
        symbolicTraits.contains(traits)
    }

    func design(_ design: SystemDesign) -> FontDescriptor {
        withDesign(design) ?? self
    }
    
    func weight(_ weight: Font.Weight) -> FontDescriptor {
        let traits : [TraitKey : Font.Weight] = [.weight: weight]
        return addingAttributes([.traits: traits])
    }
    
    func bold(_ isEnabled: Bool = true) -> FontDescriptor {
        isEnabled ? addSymbolicTraits(.bold) : removeSymbolicTraits(.bold)
    }
    
    func italic(_ isEnabled: Bool = true) -> FontDescriptor {
        isEnabled ? addSymbolicTraits(.italic) : removeSymbolicTraits(.italic)
    }
    
    func monospacedDigit() -> FontDescriptor {
        featureSetting(name: kNumberSpacingType, value: kUpperCaseSmallCapsSelector)
    }
    
    func smallCaps() -> FontDescriptor {
        uppercaseSmallCaps().lowercaseSmallCaps()
    }
    
    func uppercaseSmallCaps() -> FontDescriptor {
        featureSetting(name: kUpperCaseType, value: kUpperCaseSmallCapsSelector)
    }
    
    func lowercaseSmallCaps() -> FontDescriptor {
        featureSetting(name: kLowerCaseType, value: kLowerCaseSmallCapsSelector)
    }
    
    var isBold: Bool {
        symbolicTraitsContains(.bold)
    }
    
    var isItalic: Bool {
        symbolicTraitsContains(.italic)
    }
}

public extension Font {
    
    static func ctFont(_ font: CTFont) -> Font {
        font as Font
    }
    
    #if !os(macOS)
    static func system(_ style: TextStyle, design: FontDescriptor.SystemDesign = .default) -> Font {
        preferredFont(forTextStyle: style).design(design)
        
    }
    #endif
    
    #if os(macOS)
    func withSize(_ size: CGFloat) -> Font {
        Self.withFontDescriptor(fontDescriptor.withSize(size))
    }
    #endif
    
    static func system(size: CGFloat, weight: Weight = .regular, design: FontDescriptor.SystemDesign = .default) -> Font {
        systemFont(ofSize: size, weight: weight).design(design)
    }
    
    static func custom(_ name: String, size: CGFloat) -> Font {
        Font(name: name, size: size)!
    }
    
    static func withFontDescriptor(_ fontDescriptor: FontDescriptor) -> Font {
        #if os(macOS)
        return Font(descriptor: fontDescriptor, size: 0)!
        #else
        return Font(descriptor: fontDescriptor, size: 0) // size 0 means keep the size as it is
        #endif
    }
    
    // add feature setting
    func featureSetting(name: Int, value: Int) -> Font {
        Self.withFontDescriptor(fontDescriptor.featureSetting(name: name, value: value))
    }
    
    // set feature settings
    func setFeatureSettings(_ featureSettings: [(name: Int, value: Int)]) -> Font {
        Self.withFontDescriptor(fontDescriptor.setFeatureSettings(featureSettings))
    }
    
    // set symbolic traits
    func setSymbolicTraits(_ traits: FontDescriptor.SymbolicTraits) -> Font {
        Self.withFontDescriptor(fontDescriptor.setSymbolicTraits(traits))
    }
    
    // add symbolic traits
    func addSymbolicTraits(_ traits: FontDescriptor.SymbolicTraits) -> Font {
        Self.withFontDescriptor(fontDescriptor.addSymbolicTraits(traits))
    }
    
    // remove symbolic traits
    func removeSymbolicTraits(_ traits: FontDescriptor.SymbolicTraits) -> Font {
        Self.withFontDescriptor(fontDescriptor.removeSymbolicTraits(traits))
    }
    
    func design(_ design: FontDescriptor.SystemDesign) -> Font {
        Self.withFontDescriptor(fontDescriptor.design(design))
    }
    
    func weight(_ weight: Weight) -> Font {
        Self.withFontDescriptor(fontDescriptor.weight(weight))
    }

    func bold(_ isEnabled: Bool = true) -> Font {
        Self.withFontDescriptor(fontDescriptor.bold(isEnabled))
    }

    func italic(_ isEnabled: Bool = true) -> Font {
        Self.withFontDescriptor(fontDescriptor.italic(isEnabled))
    }
    
    func monospacedDigit() -> Font {
        Self.withFontDescriptor(fontDescriptor.monospacedDigit())
    }
    
    func smallCaps() -> Font {
        Self.withFontDescriptor(fontDescriptor.smallCaps())
    }
    
    func uppercaseSmallCaps() -> Font {
        Self.withFontDescriptor(fontDescriptor.uppercaseSmallCaps())
    }
    
    func lowercaseSmallCaps() -> Font {
        Self.withFontDescriptor(fontDescriptor.lowercaseSmallCaps())
    }
    
    var isBold: Bool {
        fontDescriptor.isBold
    }
    
    var isItalic: Bool {
        fontDescriptor.isItalic
    }
}

public extension NSAttributedString.Key {
    static let superscript = Self(rawValue: kCTSuperscriptAttributeName as String)
}

public struct SuperscriptValue {
    public static let  `subscript` = -1
    public static let superscript  =  1
}
