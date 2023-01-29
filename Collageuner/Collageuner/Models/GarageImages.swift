//
//  GarageImages.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift
//
//class GarageLists {
//    var imageList: [GarageImage]
//    var counts: Int
//    var todayDate: Date
//    
//    init(imageList: [GarageImage], counts: Int, todayDate: Date) {
//        self.imageList = imageList
//        self.counts = counts
//        self.todayDate = todayDate
//    }
//}
//
//class GarageImage: Object {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var garageThumbnailImageURL: String
//    // 이미지는 disk 에 저장을 하라. Data type 으로 직접 Realm DB 에 올리지 말고
//    // + 뭐 이런말도 있다. -> Realm Results 에는 Swift 의 .reduce 를 쓰지마라. 매우 느려진다. 대신 Realm Filter() 를 사용해라.
//    
//    convenience init(garageThumbnailImages: String) {
//        self.init()
//        
//        self.garageThumbnailImageURL = garageThumbnailImages
//    }
//}
