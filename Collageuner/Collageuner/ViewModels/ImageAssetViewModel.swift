//
//  ImageAssetViewModel.swift
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
    
    let garageImages: BehaviorRelay<[GarageImage]> = BehaviorRelay(value: [])
    
    init() {
        var garageImagesArray: [GarageImage] = []
        let realmResult = myGarageRealm.objects(GarageImage.self)
        
        realmResult.forEach {
            garageImagesArray.append($0)
        }
        
        _ = Observable.just(garageImagesArray)
            .bind(to: garageImages)
    }
    
    func addGarageImage(garageImage: UIImage) {
        let garageImageToAdd = GarageImage(usedNumber: 0)
        
        let imageName: String = garageImageToAdd._id.stringValue
        
        do {
            try myGarageRealm.write({
                myGarageRealm.add(garageImageToAdd)
                myGarageRealm.saveImagesToDocumentDirectory(imageName: imageName, image: garageImage, originalImageAt: .GarageOriginalImages, thumbnailImageAt: .GarageThumbnailImages)
            })
            print("🌅 Garage Image Added")
        } catch let error {
            print(error)
        }
    }
    
    /// Use parameter as GarageImage's _id
    func deleteGarageImage(garageImageId: String) {
        guard let realmResult = myGarageRealm.objects(GarageImage.self).filter(NSPredicate(format: "_id = %@", garageImageId)).first else {
            print("The Selected Image doesn't exist. _Id: \(garageImageId)")
            return
        }
        
        do {
            try myGarageRealm.write({
                myGarageRealm.delete(realmResult)
                myGarageRealm.deleteImageFromDirectory(fromOriginalDirectory: .GarageOriginalImages, fromThumbnailDirectory: .GarageThumbnailImages, imageName: garageImageId)
            })
            print("🗑️ Garage Image Deleted")
        } catch let error {
            print(error)
        }
    }
}
