//
//  GardenCanvas.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit
import RealmSwift

class GardenCanvas: Object {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var monthAndYear: String
    @Persisted var year: String
    // MARK: 유저가 직접 캡쳐해서 앨범에 저장되는 경우가 아니라면, 앱에서 보이는 화면에서는 항상 canvas 의 Background Color = clear 이어야 하며, 하위에 있는 UIView 의 색을 바꾸며 유저들에게 background 가 바뀐다고 인식시켜야 한다.
    @Persisted var gardenBackgroundColor: String
    
    convenience init(monthAndYear: String, year: String, gardenBackgroundColor: String) {
        self.init()
        
        self.monthAndYear = monthAndYear
        self.year = year
        self.gardenBackgroundColor = gardenBackgroundColor
    }
}
