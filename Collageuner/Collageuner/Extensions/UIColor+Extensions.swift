//
//  UIColor+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension UIColor {
        
    static var Background: UIColor {
        return UIColor(hex: "#F6F6F6")
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
    
    static var BottomSheetGreen: UIColor {
        return UIColor(hex: "#7D837B")
    }
    
    static var MorningColor: UIColor {
        return UIColor(hex: "#A8BBAF")
    }
    
    static var EarlyAfternoonColor: UIColor {
        return UIColor(hex: "#86AE96")
    }
    
    static var LateAfternoonColor: UIColor {
        return UIColor(hex: "#6F927D")
    }
}

extension UIColor {
    // Color Picker 는 return UIColor 다.
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
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
