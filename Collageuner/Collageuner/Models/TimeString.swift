//
//  TimeString.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

class TimeString {
    var year: Int
    var month: Int
    var hour: Int
    var minute: Int
    
    init(year: Int, month: Int,  hour: Int, minute: Int) {
        self.year = year
        self.month = month
        self.hour = hour
        self.minute = minute
    }
}

enum MyTimeZone: CaseIterable {
    case morningTime
    case earlyAfternoonTime
    case lateAfternoonTime
}
