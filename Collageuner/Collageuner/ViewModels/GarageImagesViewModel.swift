//
//  GarageImagesViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

final class GarageImagesViewModel {
    let myGarageRealm = try! Realm()
    
    var disposeBag = DisposeBag()
    
    let garageImages: BehaviorRelay<[GarageImage]> = BehaviorRelay(value: [])
    
    init() {
        var garageImagesArray: [GarageImage] = []
        let realmResult = myGarageRealm.objects(GarageImage.self)
        
        realmResult.forEach {
            garageImagesArray.append($0)
        }
        
        let reversedArray = Array(garageImagesArray.reversed())
        
        _ = Observable.just(reversedArray)
            .bind(to: garageImages)
            .disposed(by: disposeBag)
    }
    
    func updateGarageImages() {
        var garageImagesArray: [GarageImage] = []
        let realmResult = myGarageRealm.objects(GarageImage.self)
        
        realmResult.forEach {
            garageImagesArray.append($0)
        }
        
        let reversedArray = Array(garageImagesArray.reversed())
        
        _ = Observable.just(reversedArray)
            .bind(to: garageImages)
            .disposed(by: disposeBag)
    }
    
    func addGarageImage(pngGarageData: Data?) {
        let garageImageToAdd = GarageImage(usedNumber: 0)
        let imageName: String = garageImageToAdd._id.stringValue
        guard let pngImage = UIImage(data: pngGarageData ?? Data()) else { return }
        
        do {
            try myGarageRealm.write({
                myGarageRealm.add(garageImageToAdd)
                myGarageRealm.saveImagesToDocumentDirectory(imageName: imageName, image: pngImage, originalImageAt: .GarageOriginalImages, thumbnailImageAt: .GarageThumbnailImages)
            })
            print("🌅 Garage Image Added")
        } catch let error {
            print(error)
        }
    }
    
    /// Use parameter as GarageImage's _id
    func deleteGarageImage(garageImageId: ObjectId) {
        guard let realmResult = myGarageRealm.objects(GarageImage.self).filter(NSPredicate(format: "_id = %@", garageImageId)).first else {
            print("The Selected Image doesn't exist. _Id: \(garageImageId)")
            return
        }
        
        let imageName: String = garageImageId.stringValue
        
        do {
            try myGarageRealm.write({
                myGarageRealm.delete(realmResult)
                myGarageRealm.deleteImageFromDirectory(fromOriginalDirectory: .GarageOriginalImages, fromThumbnailDirectory: .GarageThumbnailImages, imageName: imageName)
            })
            print("🗑️ Garage Image Deleted")
        } catch let error {
            print(error)
        }
    }
    
    func isGarageEmpty() -> Bool {
        return garageImages.value.isEmpty
    }
    
    func fetchGarageOriginalImage(id: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let originalDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GarageOriginalImages.dataDirectory) else {
            print("Failed fetching directory for Original Images for Garage Sheet List")
            return UIImage(named: "TaskDefaultImage")
        }
        let imageURL = originalDirectoryURL.appending(component: "\(id).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Original Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Original Images for Garage Sheet List")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "TaskDefaultImage")
    }
    
    func fetchGarageThumbnailImage(id: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GarageThumbnailImages.dataDirectory) else {
            print("Failed fetching directory for Thumbnail Images for Garage Sheet List")
            return UIImage(named: "TaskDefaultImage")
        }
        let imageURL = thumbnailDirectoryURL.appending(component: "Thumbnail_\(id).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Thumbnail Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Thumbnail Images for Garage Sheet List")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "TaskDefaultImage")
    }
}
