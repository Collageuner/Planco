//
//  GardenImageViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

// 같이 고려해야 할 것들이
// 1. CoreData
// 2. SkickerView

class GardenImageViewModel {
//    var diposeBag = DisposeBag()
    
    private let currentGardenImage: BehaviorSubject<UIImage> = BehaviorSubject(value: UIImage())
    // UIImage() 여기에 이제 최신의 이미지가 항상 들어가 있어야 하는거지.
    
    func updateGardenImageWithNewGarden(newGarden newGardenImage: UIImage) {
        let newImage = newGardenImage
        // CoreData 에 newImage 갱신하기
        // Rx 로 BehaviorSubject 가져오기 인데...
        return
    }
}
