//
//  GarageImages.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class GarageLists {
    var imageList: [GarageImage]
    var counts: Int
    var todayDate: Date

    init(imageList: [GarageImage], counts: Int, todayDate: Date) {
        self.imageList = imageList
        self.counts = counts
        self.todayDate = todayDate
    }
}

class GarageImage: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var usedNumber: Int

    convenience init(usedNumber: Int) {
        self.init()

        self.usedNumber = usedNumber
    }
}
