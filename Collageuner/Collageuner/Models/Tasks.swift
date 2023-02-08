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
    @Persisted var taskTime: String
    @Persisted var keyForDateCheck: String
    @Persisted var mainTask: String
    @Persisted var subTasks = List<String>()
    @Persisted var taskExpiredCheck: Bool = false // 0
    @Persisted var taskCompleted: Bool = false // 0
    
    convenience init(taskTimeZone: String, taskTime: String, keyForDateCheck: String, mainTask: String, subTasks: List<String>, taskExpiredCheck: Bool, taskCompleted: Bool) {
        self.init()   
        
        self.taskTimeZone = taskTimeZone
        self.taskTime = taskTime
        self.keyForDateCheck = keyForDateCheck
        self.mainTask = mainTask
        self.subTasks = subTasks
        self.taskExpiredCheck = taskExpiredCheck
        self.taskCompleted = taskCompleted
    }
}
