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
        
        // Adding Images
        _ = myTaskRealm.objects(Tasks.self).where {
            $0.keyForDateCheck == dateKey
        }.map {
            imageStringArray.append($0.taskImageName ?? "TaskDefaultImage")
        }
        
        // Sorting Images -> 생각해보면, 그냥 Image 의 String 을 저장할 때, 날짜 + 고유번호(task_id) 이렇게 쓰면 되겠네!
        let sortedArrayOfImage = imageStringArray.sorted()
        
        _ = Observable.just(sortedArrayOfImage)
            .bind(to: taskStoryImages)
    }
    
    /// init for getting Array of Tasks
    init(dateForList: Date) {
        let dateKey = Date.dateToCheckDay(date: dateForList)
        var tasksArray: [Tasks] = []
        
        // Adding Tasks
        _ = myTaskRealm.objects(Tasks.self).where {
            $0.keyForDateCheck == dateKey
        }.map {
            tasksArray.append($0)
        }
        
        _ = Observable.just(tasksArray)
            .bind(to:taskList)
    }
    
    func createTask(timeZone: String, taskTime: Date, taskImage: String?, mainTask: String, subTasks: [String?], taskExpiredCheck: Bool, taskCompleted: Bool = false) {
        let subTaskArray = subTasks.compactMap { $0 }
        let subTaskList = List<String>()
        subTaskList.append(objectsIn: subTaskArray)
        
        let taskDateToTime = Date.dateToJoinedString(date: taskTime)
        let taskKey = Date.dateToCheckDay(date: taskTime)
        
        do {
            try myTaskRealm.write({
                myTaskRealm.add(Tasks(taskTimeZone: timeZone, taskTime: taskDateToTime, keyForDateCheck: taskKey, taskImageName: taskImage, mainTask: mainTask, subTasks: subTaskList, taskExpiredCheck: false, taskCompleted: false))
            })
        } catch let error {
            print(error)
        }
        print("🪜 Task Created")
        print(myTaskRealm.objects(Tasks.self))
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 0. 이미지 만을 위한 class 가 있었으면 좋겠는데... ✅
        // 1. Thumbnail 저장 URL 을 따로 만들어야 하나? 그러자! ✅
        // 2. Application Support 안에 새로운 directory 를 만들 수 있나? => 그냥 안 보인다. ✅
        //   a. Application Support 는 안좋을 수 있다는 이야기가 있는 것 같고... 일단은 기본 documentDirectory 로 만들어보자! 실제 앱으로 다운을 받아보고, file 을 통해서 알 수 있는지 봐보자! ✅
        //   b. Info plist 에서 Supports opening documents in place: NO 로 바꾸면? -> ⚠️ 무슨 realm 쪽에서 "bid" 오류나서 미칠뻔
        // 3. png 로 저장하고, 앱 UI 에 나올 애들은 Thumbnail 을 2개로 나눠서 큰 Thumbnail & 작은 Thumbnail 을 나눠서 앱 UI 에 표시하게 만들고, png 파일은 canvas 에 추가된 게 확인이 되면 1주일이 지나면 지워지게 만들고,
        //  -> 그냥 압축한 png 파일 하나로 thumbnail 만들고 끝내자.✅
        // 4. Subscription 을 하면, 한달까지 png 파일이 유지되게 만들어야해! ⏲️ TODO 임
        
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
            print("Original Image Saved")
        } catch let error {
            print(error)
        }
        
        do {
            try thumbnailImageData.write(to: thumbnailImageURL)
            print("Thumbnail Image Saved")
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
            print("")
            print("===============================")
            print("[ViewController >> testMain() :: 저장 된 경로 없음 >> 폴더 생성 실시]")
            print("fileSavePath :: \(originalImageURL.description)")
            print("===============================")
            print("")
            
            do {
                try FileManager.default.createDirectory(atPath: originalImageURL.path(), withIntermediateDirectories: true)
            } catch let error {
                print(error)
            }
        } else {
            print("")
            print("===============================")
            print("[ViewController >> testMain() :: 이미 저장 된 경로 있음 >> 폴더 생성 안함]")
            print("fileSavePath :: \(originalImageURL.description)")
            print("===============================")
            print("")
        }
        
        if !FileManager.default.fileExists(atPath: thumbnailImageURL.path()) {
            print("")
            print("===============================")
            print("[ViewController >> testMain() :: 저장 된 경로 없음 >> 폴더 생성 실시]")
            print("fileSavePath :: \(thumbnailImageURL.description)")
            print("===============================")
            print("")
            
            do {
                try FileManager.default.createDirectory(atPath: thumbnailImageURL.path(), withIntermediateDirectories: true)
            } catch let error {
                print(error)
            }
        } else {
            print("")
            print("===============================")
            print("[ViewController >> testMain() :: 이미 저장 된 경로 있음 >> 폴더 생성 안함]")
            print("fileSavePath :: \(thumbnailImageURL.description)")
            print("===============================")
            print("")
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
