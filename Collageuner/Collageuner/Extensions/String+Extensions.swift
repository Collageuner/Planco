//
//  String+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension String {
    var emptyToNil: String? {
        if self.isEmpty {
            return nil
        } else {
            return self
        }
    }
    
    /// Returns h:mm am
    var changeAmPmToString: String {
        let hour: String = String(self.prefix(2))
        let minute: String = String(self.suffix(2))
        let hourToInt: Int = Int(hour) ?? 0
        
        switch hourToInt {
        case 0...11:
            return "\(hourToInt):\(minute) am"
        case 12...23:
            return "\(hourToInt - 12):\(minute) pm"
        default:
            print("Error changing time h:mm AmPm")
            return ""
        }
    }
    
    /// Returns h:mm
    var changeHourIntoShort: String {
        let hour: String = String(self.prefix(2))
        let minute: String = String(self.suffix(2))
        let hourToInt: Int = Int(hour) ?? 0
        
        switch hourToInt {
        case 0...11:
            return "\(hourToInt):\(minute)"
        case 12...23:
            return "\(hourToInt - 12):\(minute)"
        default:
            print("Error changing time h:mm")
            return ""
        }
    }
}
