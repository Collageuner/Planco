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
        let subTaskArray = subTasks.compactMap { $0 }
        let subTaskList = List<String>()
        subTaskList.append(objectsIn: subTaskArray)
        
        let taskDateToTime = Date.dateToJoinedString(date: taskTime)
        let taskKey = Date.dateToCheckDay(date: taskTime)
        
        let taskToCreate: Tasks = Tasks(taskTimeZone: timeZone, taskTime: taskDateToTime, keyForDateCheck: taskKey, mainTask: mainTask, subTasks: subTaskList, taskExpiredCheck: false, taskCompleted: false)
        
        let imageName: String = taskToCreate.taskTime + taskToCreate._id.stringValue
        
        do {
            try myTaskRealm.write({
                myTaskRealm.add(taskToCreate)
                saveImageToDocumentDirectory(imageName: imageName, image: taskImage ?? UIImage())
            })
        } catch let error {
            print(error)
        }
        print("🪜 Task Created")
    }
    
    func updateTask() {
        
        
        
    }
    
    private func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 1. Subscription 을 하면, 한달까지 png 파일이 유지되게 만들어야해! ⏲️ TODO 임
        
        createDocumentDirectory()
        
        guard let originalImageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.OriginalImages.dataDirectory) else {
            print("Error locating Directory")
            return
        }
        
        guard let thumbnailImageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.ThumbnailImages.dataDirectory) else {
            print("Error locating Directory")
            return
        }
        
        let originalImageURL = originalImageWriteDirectory.appending(component: "\(imageName).png")
        
        let thumbnailImageURL = thumbnailImageWriteDirectory.appending(path: "Thumbnail_\(imageName).png")
        let resizedImageForThumbnail = resizeImageForThumbnail(image: image, cgsize: 100)
        
        guard let originalImageData = image.pngData() else {
            print("Failed to Compress Image into .png")
            return
        }
        guard let thumbnailImageData = resizedImageForThumbnail.pngData() else {
            print("Failed to Compress Image into thumbnail Image")
            return
        }
        
        do {
            try originalImageData.write(to: originalImageURL)
            print("🌕 Original Image Saved")
        } catch let error {
            print(error)
        }
        
        do {
            try thumbnailImageData.write(to: thumbnailImageURL)
            print("🌙 Thumbnail Image Saved")
        } catch let error {
            print(error)
        }
    }
    
    private func createDocumentDirectory() {
        guard let imageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error locating Directory")
            return
        }
        
        let originalImageURL = imageWriteDirectory.appending(component: DirectoryForWritingData.OriginalImages.dataDirectory)
        let thumbnailImageURL = imageWriteDirectory.appending(component: DirectoryForWritingData.ThumbnailImages.dataDirectory)
        
        if !FileManager.default.fileExists(atPath: originalImageURL.path()) {
            print("===============================")
            print("[ViewController >> testMain() :: 저장 된 경로 없음 >> 폴더 생성 실시]")
            print("===============================")
            
            do {
                try FileManager.default.createDirectory(atPath: originalImageURL.path(), withIntermediateDirectories: true)
            } catch let error {
                print(error)
            }
        } else {
            print("===============================")
            print("[ViewController >> testMain() :: 이미 저장 된 경로 있음 >> 폴더 생성 안함]")
            print("===============================")
        }
        
        if !FileManager.default.fileExists(atPath: thumbnailImageURL.path()) {
            print("===============================")
            print("[ViewController >> testMain() :: 저장 된 경로 없음 >> 폴더 생성 실시]")
            print("===============================")
            
            do {
                try FileManager.default.createDirectory(atPath: thumbnailImageURL.path(), withIntermediateDirectories: true)
            } catch let error {
                print(error)
            }
        } else {
            print("===============================")
            print("[ViewController >> testMain() :: 이미 저장 된 경로 있음 >> 폴더 생성 안함]")
            print("===============================")
        }
    }
    
    /// Recommended cgsize is around 90.
    private func resizeImageForThumbnail(image: UIImage, cgsize: Int) -> UIImage {
        let thumbnailSize = CGSize(width: cgsize, height: cgsize)
        let scaledImage = image.scalePreservingAspectRatio(targetSize: thumbnailSize)
        
        return scaledImage
    }
    
//    func updateTask(timeZone: String, taskTime: Date, taskImage: String?, mainTask: String, subTasks: [String?], taskExpiredCheck: Bool, taskCompleted: Bool) {
//        let subTaskArray = subTasks.compactMap { $0 }
//        let subTaskList = List<String>()
//        subTaskList.append(objectsIn: subTaskArray)
//
//        let dateKey = Date.dateToJoinedString(date: taskTime)
//
//        do {
//            try myTaskRealm.write({
//                guard let taskToUpdate = myTaskRealm.objects(Tasks.self).where { $0.taskTime == dateKey }.first else {
//                    print("Failed to find object with dateKey")
//                    return }
//                taskToUpdate.taskTime = dateKey
//            })
//        } catch let error {
//            print(error)
//        }
//        print("✨ Task Updated")
//        print(myTaskRealm.objects(Tasks.self))
//    }
 
    /// 결국에 tableView 에서 어떻게 데이터 전달이 돼서 새로운 변수만 있으면 되는건지 아니면 조회를 해야하는건지...
//    func deleteTask
    
//    func finishTask
}
