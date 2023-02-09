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

//class imageAssetViewModel: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
//
//    @Persisted var imageURL: String
//    @Persisted var addedDate: Date
//
//    init(imageURL: String, addedDate: Date) {
//        self.init()
//
//        self.imageURL = imageURL
//        self.addedDate = addedDate
//    }
//}

class GarageImagesViewModel {
    let myGarageRealm = try! Realm()
    
    let garageImages: BehaviorRelay<[GarageImage]> = BehaviorRelay(value: [])
    
    init() {}
    
    func AddGarageImage(garageImage: UIImage) {
        
    }
    
    func deleteGarageImage() {
        
    }
    
    private func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        
    }
    
    
}
