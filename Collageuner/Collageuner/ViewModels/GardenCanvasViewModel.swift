//
//  GardenCanvasViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

    // MARK: 한번 다듬을 필요가 있음
final class GardenCanvasViewModel {
    let myGardenCanvasRealm = try! Realm()
    
    var disposeBag = DisposeBag()
    
    let currentGardenCanvas: BehaviorRelay<GardenCanvas> = BehaviorRelay(value: GardenCanvas())
    let collectionOfCanvas: BehaviorRelay<[GardenCanvas]> = BehaviorRelay(value: [])
    
    /// Get a single Canvas Image of the month.
    init(currentDate: Date) {
        let dateKey: String = Date.dateToYearAndMonth(date: currentDate)
        
        guard let realmResult = myGardenCanvasRealm.objects(GardenCanvas.self).filter(NSPredicate(format: "monthAndYear = %@", dateKey)).first else {
            print("⚠️ Failed To Fetch GardenCanvas")
            return
        }
        
        _ = Observable.just(realmResult)
            .bind(to: currentGardenCanvas)
            .disposed(by: disposeBag)
    }
    
    /// Get array of Canvas Thumbnail Images of the year.
    init(specificYear: String) {
        let dateKey: String = String(specificYear.suffix(2))
        var canvasOfYearArray: [GardenCanvas] = []
        
        let realmResult = myGardenCanvasRealm.objects(GardenCanvas.self).filter(NSPredicate(format: "year = %@", dateKey))
        
        realmResult.forEach {
            canvasOfYearArray.append($0)
        }
        
        _ = Observable.just(canvasOfYearArray)
            .bind(to: collectionOfCanvas)
            .disposed(by: disposeBag)
    }
    
    func saveCurrentCanvas(modifiedCanvasImage: UIImage, backgroundColor: UIColor, date: Date) {
        let dateKey: String = Date.dateToYearAndMonth(date: date)
        let year: String = String(dateKey.prefix(2))
        
        let backgroundColorString: String = backgroundColor.toHexString()
        let canvasToCreate = GardenCanvas(monthAndYear: dateKey, year: year, gardenBackgroundColor: backgroundColorString)
        
        let imageName: String = "\(canvasToCreate.monthAndYear)_Canvas"
        
        do {
            try myGardenCanvasRealm.write({
                myGardenCanvasRealm.add(canvasToCreate)
                myGardenCanvasRealm.saveImagesToDocumentDirectory(imageName: imageName, image: modifiedCanvasImage, originalImageAt: .GardenOriginalImages, thumbnailImageAt: .GardenThumbnailImages)
            })
            print("🖼️ Garden Canvas Saved")
        } catch let error {
            print(error)
        }
    }
    
    func fetchSpecifirYearsCanvas(specificYear: String) {
        let dateKey: String = String(specificYear.suffix(2))
        var canvasOfYearArray: [GardenCanvas] = []
        
        let realmResult = myGardenCanvasRealm.objects(GardenCanvas.self).filter(NSPredicate(format: "year = %@", dateKey))
        
        realmResult.forEach {
            canvasOfYearArray.append($0)
        }
        
        _ = Observable.just(canvasOfYearArray)
            .bind(to: collectionOfCanvas)
            .disposed(by: disposeBag)
    }
    
    private func dateToYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        
        return dateFormatter.string(from: date)
    }
}
