//
//  UIColor+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension UIColor {
        
    static var Background: UIColor {
        return UIColor(hex: "#F8F8F8")
    }
    
    static var MainText: UIColor {
        return UIColor(hex: "#494949")
    }
    
    static var SubText: UIColor {
        return UIColor(hex: "#767676")
    }
    
    static var MainGreen: UIColor {
        return UIColor(hex: "#425846")
    }
    
    static var SubGreen: UIColor {
        return UIColor(hex: "#596952")
    }
    
    static var PopGreen: UIColor {
        return UIColor(hex: "#87B69A")
    }
    
    static var MainGray: UIColor {
        return UIColor(hex: "#D9D9D9")
    }
    
    static var SubGray: UIColor {
        return UIColor(hex: "#949494")
    }
    
    static var MainCalendar: UIColor {
        return UIColor(hex: "#EEC17D")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
