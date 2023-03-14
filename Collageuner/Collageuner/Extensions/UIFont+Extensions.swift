//
//  UIFont+Extension.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension UIFont {
    static func preferredFont(forTextStyle: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: forTextStyle)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: forTextStyle)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
    static func customEnglishFont(_ font: Anton, forTextStyle style: UIFont.TextStyle, overrideFontSize: UIContentSizeCategory? = nil) -> UIFont? {
        guard let customFont = UIFont(name: font.fontName(), size: font.fontSize(style: style)) else { return nil }
        let scaledFont: UIFont
        let metrics = UIFontMetrics(forTextStyle: style)
        scaledFont = metrics.scaledFont(for: customFont, compatibleWith: UITraitCollection(preferredContentSizeCategory: overrideFontSize ?? .unspecified))
        return scaledFont
    }
    
    static func customVersatileFont(_ font: AppleSDNeo, forTextStyle style: UIFont.TextStyle, overrideFontSize: UIContentSizeCategory? = nil) -> UIFont? {
        guard let customFont = UIFont(name: font.fontName(), size: font.fontSize(style: style)) else { return nil }
        let scaledFont: UIFont
        let metrics = UIFontMetrics(forTextStyle: style)
        scaledFont = metrics.scaledFont(for: customFont, compatibleWith: UITraitCollection(preferredContentSizeCategory: overrideFontSize ?? .unspecified))
        return scaledFont
    }
}

enum Anton {
    case regular
    
    func fontName() -> String {
        switch self {
        case .regular:
            return "Anton-Regular"
        }
    }
    
    func fontSize(style: UIFont.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: return 38.0
        case .title1: return 26.0
        case .title2: return 22.0
        case .title3: return 20.0
        case .headline: return 18.0
        case .body: return 17.0
        case .callout: return 16.0
        case .subheadline: return 15.0
        case .footnote: return 13.0
        case .caption1: return 12.0
        case .caption2: return 11.0
        default: return 17.0
        }
    }
}

enum AppleSDNeo {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    
    func fontName() -> String {
        switch self {
        case .ultraLight: return "AppleSDGothicNeo-UltraLight"
        case .thin: return "AppleSDGothicNeo-Thin"
        case .light: return "AppleSDGothicNeo-Light"
        case .regular: return "AppleSDGothicNeo-Regular"
        case .medium: return "AppleSDGothicNeo-Medium"
        case .semibold: return "AppleSDGothicNeo-SemiBold"
        case .bold: return "AppleSDGothicNeo-Bold"
        }
    }
    
    func fontSize(style: UIFont.TextStyle) -> CGFloat {
            switch style {
            case .largeTitle: return 30.0
            case .title1: return 25.0
            case .title2: return 22.0
            case .title3: return 20.0
            case .headline: return 18.0
            case .body: return 17.0
            case .callout: return 16.0
            case .subheadline: return 15.0
            case .footnote: return 13.0
            case .caption1: return 12.0
            case .caption2: return 11.0
            default: return 17.0
            }
        }
}

/// To Find Fonts Included in Xcode
/*
 
 UIFont.familyNames.forEach({ familyName in
     let fontNames = UIFont.fontNames(forFamilyName: familyName)
     print(familyName, fontNames)
 })
 
 */

/*
 EBGaramond-Regular
 EBGaramond-Italic
 EBGaramondRoman-Medium
 EBGaramondItalic-Medium
 EBGaramondRoman-SemiBold
 EBGaramondItalic-SemiBold
 EBGaramondRoman-Bold
 EBGaramondItalic-Bold
 EBGaramondRoman-ExtraBold
 EBGaramondItalic-ExtraBold
 */
