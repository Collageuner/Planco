//
//  TimeString.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

final class HourMinuteString {
    var hour: String
    var minute: String
    var noon: String
    
    init(hour: String, minute: String, noon: String) {
        self.hour = hour
        self.minute = minute
        self.noon = noon
    }
}

final class MyTimeZoneString: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var hour: String
    @Persisted var minute: String
    @Persisted var timeZone: String
    @Persisted var noon: String
    
    convenience init(hour: String, minute: String, timeZone: String, noon: String) {
        self.init()
        
        self.hour = hour
        self.minute = minute
        self.timeZone = timeZone
        self.noon = noon
    }
    
    /// Returns -> "HH:mm:00"
    func hourToFullHour() -> String {
        if hour == "12" {
            return hour + ":" + minute + ":00"
        }
        
        switch noon {
        case "am":
            return hour + ":" + minute + ":00"
        case "pm":
            guard let addedHour = Int(hour) else { return "12:00"}
            return String(addedHour + 12) + ":" + minute + ":00"
        default:
            return "12:00"
        }
    }
}

enum MyTimeZone: String, CaseIterable {
    case morningTime
    case earlyAfternoonTime
    case lateAfternoonTime
    
    var time: String {
        switch self {
        case .morningTime:
            return "morningTime"
        case .earlyAfternoonTime:
            return "earlyAfternoonTime"
        case .lateAfternoonTime:
            return "lateAfternoonTime"
        }
    }
}
