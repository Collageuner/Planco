//
//  Tasks.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class Tasks: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var taskTimeZone: String
    @Persisted var taskTime: TimeString?
    @Persisted var taskImage: String?
//    @Persisted var taskThumbnailImage: String? // 이것도 VM 에서 처리
    @Persisted var mainTask: String
    @Persisted var subTasks = List<String>()
    @Persisted var tasksCount: Int = 2
    @Persisted var taskExpiredCheck: Bool = false
    @Persisted var taskCompleted: Bool = false
    
    convenience init(taskTimeZone: String, taskTime: TimeString? = nil, taskImage: String? = nil, mainTask: String, subTasks: List<String>, tasksCount: Int, taskExpiredCheck: Bool, taskCompleted: Bool) {
        self.init()   
        
        self.taskTimeZone = taskTimeZone
        self.taskTime = taskTime
        self.taskImage = taskImage
        self.mainTask = mainTask
        self.subTasks = subTasks
        self.tasksCount = tasksCount
        self.taskExpiredCheck = taskExpiredCheck
        self.taskCompleted = taskCompleted
    }
}
