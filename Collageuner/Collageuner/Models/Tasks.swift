//
//  Tasks.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class Tasks: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var taskTimeZone: String
    @Persisted var taskTime: String // yyMMddHHmm - 2302121831
    @Persisted var keyForYearAndMonthCheck: String // yyMM - 2302
    @Persisted var keyForDayCheck: String // yyMMdd - 230212
    @Persisted var mainTask: String
    @Persisted var subTasks = List<String>()
    @Persisted var taskExpiredCheck: Bool = false // 0
    @Persisted var taskCompleted: Bool = false // 0
    
    convenience init(taskTimeZone: String, taskTime: String, keyForYearAndMonthCheck: String, keyForDayCheck: String, mainTask: String, subTasks: List<String>, taskExpiredCheck: Bool, taskCompleted: Bool) {
        self.init()   
        
        self.taskTimeZone = taskTimeZone
        self.taskTime = taskTime
        self.keyForYearAndMonthCheck = keyForYearAndMonthCheck
        self.keyForDayCheck = keyForDayCheck
        self.mainTask = mainTask
        self.subTasks = subTasks
        self.taskExpiredCheck = taskExpiredCheck
        self.taskCompleted = taskCompleted
    }
}
