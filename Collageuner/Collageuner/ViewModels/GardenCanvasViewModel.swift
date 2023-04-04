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
        
        if let realmResult = myGardenCanvasRealm.objects(GardenCanvas.self).filter(NSPredicate(format: "monthAndYear = %@", dateKey)).first {
            _ = Observable.just(realmResult)
                .bind(to: currentGardenCanvas)
                .disposed(by: disposeBag)
        } else {
            print("⚠️ Failed To Fetch GardenCanvas")
            print("❇️ Saving this month's fresh Canvas")
            saveCurrentCanvas(modifiedCanvasImage: UIImage(named: "DefaultCanvasImage") ?? UIImage(), backgroundColor: .Background, date: currentDate)
            guard let newRealmResult = myGardenCanvasRealm.objects(GardenCanvas.self).filter(NSPredicate(format: "monthAndYear = %@", dateKey)).first else { return }
            _ = Observable.just(newRealmResult)
                .bind(to: currentGardenCanvas)
                .disposed(by: disposeBag)
        }
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
    
    func fetchCurrentDateCanvas(currentDate: Date) -> UIImage {
        let dateKey: String = Date.dateToYearAndMonth(date: currentDate)
        guard let fetchedCanvasImage =  loadGardenCanvasFromDirectory(imageName: dateKey) else { return UIImage(named: "DefaultCanvasImage") ?? UIImage() }
        
        return fetchedCanvasImage
    }
    
    private func dateToYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        
        return dateFormatter.string(from: date)
    }
    
    private func loadGardenCanvasFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GardenOriginalImages.dataDirectory) else {
            print("Failed fetching directory for Images for Garden Image")
            return UIImage(named: "DefaultCanvasImage")
        }
        
        let imageURL = thumbnailDirectoryURL.appending(component: "\(imageName)_Canvas.png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Garden Canvas Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Images for Garden Image")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "DefaultCanvasImage")
    }
}
