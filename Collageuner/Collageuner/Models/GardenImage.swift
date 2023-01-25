//
//  GardenImage.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

class GardenImage {
    var gardenUUID: String
    var currentGardenImage: UIImage? // 현재의 빈 캔버스에서 시작.
    var gardenThumbnailImage: UIImage?
    var month: Int
    var year: Int
    var gardenBackgroundColor: UIColor = UIColor.Background
    
    init(gardenUUID: String, currentGardenImage: UIImage? = nil, gardenThumbnailImage: UIImage? = nil, month: Int, year: Int, gardenBackgroundColor: UIColor = UIColor.white) {
        self.gardenUUID = gardenUUID
        self.currentGardenImage = currentGardenImage
        self.gardenThumbnailImage = gardenThumbnailImage
        self.month = month
        self.year = year
        self.gardenBackgroundColor = gardenBackgroundColor
    }
}
