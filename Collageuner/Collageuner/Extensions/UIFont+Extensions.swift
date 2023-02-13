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
    
    static func customEnglishFont(_ font: EBGaramond, forTextStyle style: UIFont.TextStyle, overrideFontSize: UIContentSizeCategory? = nil) -> UIFont? {
        guard let customFont = UIFont(name: font.fontName(), size: font.fontSize(style: style)) else { return nil }
        let scaledFont: UIFont
        let metrics = UIFontMetrics(forTextStyle: style)
        scaledFont = metrics.scaledFont(for: customFont, compatibleWith: UITraitCollection(preferredContentSizeCategory: overrideFontSize ?? .unspecified))
        return scaledFont
    }
    
    static func customVersatileFont(_ font: AppleSDNeo, forTextStyle style: UIFont.TextStyle, overrideFontSize: UIContentSizeCategory? = nil) -> UIFont? {
        return nil
    }
}

enum EBGaramond {
    case regualar
    case medium
    case semibold
    case bold
    case extrabold
    
    func fontName() -> String {
        switch self {
        case .regualar: return "EBGaramond-Regular"
        case .medium: return "EBGaramondRoman-Medium"
        case .semibold: return "EBGaramondRoman-SemiBold"
        case .bold: return "EBGaramondRoman-Bold"
        case .extrabold: return "EBGaramondRoman-ExtraBold"
        }
    }
    
    func fontSize(style: UIFont.TextStyle) -> CGFloat {
            switch style {
            case .largeTitle: return 34.0
            case .title1: return 28.0
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
    case regualar
    case medium
    case semibold
    case bold
    
    func fontName() -> String {
        switch self {
        case .ultraLight: return "AppleSDGothicNeo-UltraLight"
        case .thin: return "AppleSDGothicNeo-Thin"
        case .light: return "AppleSDGothicNeo-Light"
        case .regualar: return "AppleSDGothicNeo-Regular"
        case .medium: return "AppleSDGothicNeo-Medium"
        case .semibold: return "AppleSDGothicNeo-SemiBold"
        case .bold: return "AppleSDGothicNeo-Bold"
        }
    }
    
    func fontSize(style: UIFont.TextStyle) -> CGFloat {
            switch style {
            case .largeTitle: return 34.0
            case .title1: return 28.0
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
