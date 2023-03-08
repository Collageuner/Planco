//
//  Date+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/02.
//

import UIKit

extension Date {
    /// Returns -> "yyyy-MM-dd"
    static func prefixOfStringToDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    /// Returns -> "yyMM"
    static func dateToYearAndMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMM"
                
        return dateFormatter.string(from: date)
    }
    
    /// Returns -> "yyMMdd"
    static func dateToCheckDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
                
        return dateFormatter.string(from: date)
    }
    
    /// Returns -> "yyMMddHHmm"
    static func fullDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmm"
        
        return dateFormatter.string(from: date)
    }
    
    /// Returns -> "h:ss"
    static func hourMinuteJoinedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:ss"
        
        return dateFormatter.string(from: date)
    }
}

