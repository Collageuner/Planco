//
//  Date+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/02.
//

import UIKit

extension Date {
    func dateToJoinedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmm"
        
        return dateFormatter.string(from: date)
    }
}

