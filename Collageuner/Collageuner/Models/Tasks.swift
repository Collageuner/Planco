//
//  Tasks.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

class Tasks {
    var taskTimeZone: MyTimeZone
    var taskTime: TimeString
    var taskImage: UIImage?
    var taskThumbnailImage: UIImage?
    var mainTask: String
    var subTasks: [String]?
    var tasksCount: Int = 2
    
    init(taskTimeZone: MyTimeZone, taskTime: TimeString, taskImage: UIImage? = nil, taskThumbnailImage: UIImage? = nil, mainTask: String, subTasks: [String]? = nil, tasksCount: Int) {
        self.taskTimeZone = taskTimeZone
        self.taskTime = taskTime
        self.taskImage = taskImage
        self.taskThumbnailImage = taskThumbnailImage
        self.mainTask = mainTask
        self.subTasks = subTasks
        self.tasksCount = tasksCount
    }
}
