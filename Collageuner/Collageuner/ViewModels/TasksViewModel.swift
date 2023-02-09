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
    
    let taskStoryImages: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let taskList: BehaviorRelay<[Tasks]> = BehaviorRelay(value: [])
    
    /// init for getting HomeView Story Images
    init(dateForStories: Date) {
        let dateKey = Date.dateToCheckDay(date: dateForStories)
        var imageStringArray: [String] = []
        
        let realmResult = myTaskRealm.objects(Tasks.self).filter(NSPredicate(format: "keyForDateCheck = %@", dateKey))
        
        realmResult.forEach{
            let imageName: String = "Thumbnail_\($0.taskTime)\($0._id.stringValue).png"
            imageStringArray.append(imageName)
        }

        let sortedArrayOfImage = imageStringArray.sorted()
        _ = Observable.just(sortedArrayOfImage)
            .bind(to: taskStoryImages)
    }
    
    /// init for getting Array of Tasks
    init(dateForList: Date) {
        let dateKey = Date.dateToCheckDay(date: dateForList)
        var tasksArray: [Tasks] = []
        
        let realmResult = myTaskRealm.objects(Tasks.self).filter(NSPredicate(format: "keyForDateCheck = %@", dateKey))
            
        realmResult.forEach {
            tasksArray.append($0)
        }
        
        _ = Observable.just(tasksArray)
            .bind(to:taskList)
    }
    
    func createTask(timeZone: String, taskTime: Date, taskImage: UIImage?, mainTask: String, subTasks: [String?] = [], taskExpiredCheck: Bool = false, taskCompleted: Bool = false) {
        let subTaskList = arrayToListRealm(swiftArray: subTasks)
        
        let taskDateToTime = Date.dateToJoinedString(date: taskTime)
        let taskKey = Date.dateToCheckDay(date: taskTime)
        
        let taskToCreate: Tasks = Tasks(taskTimeZone: timeZone, taskTime: taskDateToTime, keyForDateCheck: taskKey, mainTask: mainTask, subTasks: subTaskList, taskExpiredCheck: false, taskCompleted: false)
        
        let imageName: String = taskToCreate.taskTime + taskToCreate._id.stringValue
        
        do {
            try myTaskRealm.write({
                myTaskRealm.add(taskToCreate)
                myTaskRealm.saveImagesToDocumentDirectory(imageName: imageName, image: taskImage ?? UIImage(), originalImageAt: .TaskOriginalImages, thumbnailImageAt: .TaskThumbnailImages)
            })
        } catch let error {
            print(error)
        }
        print("🪜 Task Created")
    }
    
//    func updateTask(timeZone: String, taskTime: Date, taskImage: UIImage?, mainTask: String, subTasks: [String?] = []) {
//        let subTaskList = arrayToListRealm(swiftArray: subTasks)
//
//        let taskDateToTime = Date.dateToJoinedString(date: taskTime)
//        let taskKey = Date.dateToCheckDay(date: taskTime)
//
//
//
//    }
    
    private func arrayToListRealm(swiftArray: [String?]) -> List<String> {
        let subTaskArray = swiftArray.compactMap { $0 }
        let subTaskList = List<String>()
        subTaskList.append(objectsIn: subTaskArray)
        
        return subTaskList
    }

    /// 결국에 tableView 에서 어떻게 데이터 전달이 돼서 새로운 변수만 있으면 되는건지 아니면 조회를 해야하는건지...
//    func deleteTask
    
//    func finishTask
}
