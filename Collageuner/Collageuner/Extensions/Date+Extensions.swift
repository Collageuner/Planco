//
//  Date+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/02.
//

import UIKit

extension Date {
    static func dateToCheckDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
                
        return dateFormatter.string(from: date)
    }
    
    static func dateToJoinedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        
        return dateFormatter.string(from: date)
    }
    
    static func hourMinuteJoinedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:ss"
        
        return dateFormatter.string(from: date )
    }
}

