//
//  TasksViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

class TasksViewModel {
    let myTaskRealm = try! Realm()
    
    func saveTask(timeZone: String, taskTime: TimeString, image: String?, mainTask: String, subTasks: [String?], tasksCount: Int = 2, taskExpiredCheck: Bool, taskCompleted: Bool = false) {
        
        let subTaskArray = subTasks.compactMap { $0 }
        let subTaskList = List<String>()
        subTaskList.append(objectsIn: subTaskArray)
        
        try! myTaskRealm.write({
            myTaskRealm.add(Tasks(taskTimeZone: timeZone, taskTime: taskTime, taskImage: image, mainTask: mainTask, subTasks: subTaskList, tasksCount: tasksCount, taskExpiredCheck: false, taskCompleted: false))
        })
        print("Task Saved")
        print(myTaskRealm.objects(Tasks.self))
    }
    
    func updateTask(taskTime: TimeString, image: String?, mainTask: String, subTasks: [String?], tasksCount: Int = 2, taskExpiredCheck: Bool, taskCompleted: Bool = false) {
        
    }
}
