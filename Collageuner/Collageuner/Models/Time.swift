//
//  MyTimeZone.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

struct TimeString {
    var year: Int
    var month: Int
    var hour: Int
    var minute: Int
}

enum MyTimeZone: CaseIterable {
    case morningTime
    case earlyAfternoonTime
    case lateAfternoonTime
    
    // return UserDefaults
    var timeZoneString: String {
        switch self {
        case .morningTime:
            return "🕖 07:00-12:00"
        case .earlyAfternoonTime:
            return "🕐 12:00-18:00"
        case .lateAfternoonTime:
            return "🕕 18:00-24:00"
        }
    }
}

// enum -> 1주일 치 date 나타내기..? (미정)
