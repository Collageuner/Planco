//
//  GardenImage.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit
import RealmSwift

class GardenImage: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var currentGardenImage: String // 기본 Assest 에 흰색 이미지를 넣고 그걸로 처리하기, 분기 처리는 VM 에서!
//    @Persisted var gardenThumbnailImage: UIImage? // ViewModel 에서 String 을 받아와서 크기 처리 후 내보내는 걸로 만들기.
    @Persisted var month: Int
    @Persisted var year: Int
    @Persisted var gardenBackgroundColor: String
    // Color 를 저장하는 것도 따로 Extension 이 필요하겠다.
    
    convenience init(gardenUUID: String, currentGardenImage: String, month: Int, year: Int, gardenBackgroundColor: String) {
        self.init()
        
        self.currentGardenImage = currentGardenImage
        self.month = month
        self.year = year
        self.gardenBackgroundColor = ".Background"
    }
}
