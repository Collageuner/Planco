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
    
    func createTask(timeZone: String, taskTime: Date, taskImage: String?, mainTask: String, subTasks: [String?], taskExpiredCheck: Bool, taskCompleted: Bool = false) {
        let subTaskArray = subTasks.compactMap { $0 }
        let subTaskList = List<String>()
        subTaskList.append(objectsIn: subTaskArray)

        do {
            try myTaskRealm.write({
                myTaskRealm.add(Tasks(taskTimeZone: timeZone, taskTime: taskTime, taskImage: taskImage, mainTask: mainTask, subTasks: subTaskList, taskExpiredCheck: false, taskCompleted: false))
            })
        } catch let error {
            print(error)
        }
        print("🪜 Task Created")
        print(myTaskRealm.objects(Tasks.self))
    }
    
//    func updateTask(id: ObjectId, taskTime: Date, taskImage: String?, mainTask: String, subTasks: [String?], taskExpiredCheck: Bool, taskCompleted: Bool = false) -> Bool {
//        let subTaskArray = subTasks.compactMap { $0 }
//        let subTaskList = List<String>()
//        subTaskList.append(objectsIn: subTaskArray)
//        
//        guard let taskToUpdate = myTaskRealm.objects(Tasks.self).where({ $0.id == id }).first else {
//            print("Failed finding objects to update.")
//            return false }
//        
//        
//        taskToUpdate.taskImage = taskImage
//        taskToUpdate.mainTask = mainTask
//        taskToUpdate.subTasks = subTaskList
//        taskToUpdate.taskTime = taskTime
//        return true
//    }
}
