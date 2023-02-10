//
//  GardenImage.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit
import RealmSwift

class GardenCanvas: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gardenImage: String // 기본 Assest 에 흰색 이미지를 넣고 그걸로 처리하기, 분기 처리는 VM 에서!
//    @Persisted var gardenThumbnailImage: UIImage? // ViewModel 에서 String 을 받아와서 크기 처리 후 내보내는 걸로 만들기.
    @Persisted var month: Int
    @Persisted var year: Int
    @Persisted var gardenBackgroundColor: String
    
    convenience init(gardenUUID: String, currentGardenImage: String, month: Int, year: Int, gardenBackgroundColor: String) {
        self.init()
        
        self.gardenImage = currentGardenImage
        self.month = month
        self.year = year
        self.gardenBackgroundColor = gardenBackgroundColor
    }
}
