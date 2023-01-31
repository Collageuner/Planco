//
//  TimeString.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class TimeString: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var year: Int
    @Persisted var month: Int
    @Persisted var day: Int
    @Persisted var hour: Int
    @Persisted var minute: Int
    
    convenience init(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        self.init()
        
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
    }
}

class MyTimeZoneString: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var hour: String
    @Persisted var minute: String
    @Persisted var timeZone: String
    
    convenience init(hour: String, minute: String, timeZone: String) {
        self.init()
        
        self.hour = hour
        self.minute = minute
        self.timeZone = timeZone
    }
}

enum MyTimeZone: String, CaseIterable {
    case morningTime
    case earlyAfternoonTime
    case lateAfternoonTime
}
