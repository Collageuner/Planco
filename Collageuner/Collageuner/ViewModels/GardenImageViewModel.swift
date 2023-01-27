//
//  GardenImageViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import RxCocoa
import RxSwift

// 같이 고려해야 할 것들이
// 1. CoreData
// 2. Sketch

class GardenImageViewModel {
    var diposeBag = DisposeBag()
    
    private let currentGardenImage: BehaviorSubject<UIImage> = BehaviorSubject(value: UIImage())
    // 여기에 이제 최신의 이미지가 항상 들어가 있어야 하는거지.
    
//    func
}
