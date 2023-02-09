//
//  RealmManager.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/29.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

extension Realm {
    
    // 일단 이렇게 해놓고 고도화 시켜보자 일단은! write 에 대해서도 정확한 func 을 만들고 해당 thread Safe 나 구동 safe 에 대한 공식적인 이야기가 확실해지면 그때 사용하도록 해보자. 실제 사용하면서 에러도 찾아야 하니깐!
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print(error)
            print("⚠️ Fetching Realm Failed")
            
            return nil
        }
    }
    
    // TODO: Realm Extension 에서 만드는건 어때?
    /// ㄴ> 궁금한게 Realm 에 extension 해서 메서드 사용하는게 괜찮은 건가? 성능 이슈가 생기진 않겠지? => 일단 해보자.
    /// 폴더가 존재한다면 -> 분기 처리를 하는게 좋을까 아니면 그냥 한장한장 할때마다 하는게 좋을까 근데 적으면서 생각을 해보니깐 어차피 이미지를 대량으로 한번에 처리하지는 않기 때문에 safe 핑계로 냅둬도 괜찮을듯하다.
    func saveImagesToDocumentDirectory(imageName: String, image: UIImage, originalImageAt originalImageDirectory: DirectoryForWritingData, thumbnailImageAt thumbnailImageDirectory: DirectoryForWritingData) {
        
        createDocumentDirectory(at: originalImageDirectory.dataDirectory)
        createDocumentDirectory(at: thumbnailImageDirectory.dataDirectory)
        
        guard let originalImageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: originalImageDirectory.dataDirectory) else {
            print("Error locating Directory: Original Image")
            return
        }
        
        guard let thumbnailImageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: thumbnailImageDirectory.dataDirectory) else {
            print("Error locating Directory: Thumbnail Image")
            return
        }
        
        let originalImageURL = originalImageWriteDirectory.appending(component: "\(imageName).png")
        
        let thumbnailImageURL = thumbnailImageWriteDirectory.appending(path: "Thumbnail_\(imageName).png")
        let resizedImageForThumbnail = resizeImageForThumbnail(image: image, cgsize: 100)
        
        guard let originalImageData = image.pngData() else {
            print("Failed to Compress Image into .png")
            return
        }
        guard let thumbnailImageData = resizedImageForThumbnail.pngData() else {
            print("Failed to Compress Image into thumbnail Image")
            return
        }
        
        do {
            try originalImageData.write(to: originalImageURL)
            print("🌕 Original Image Saved")
        } catch let error {
            print(error)
        }
        
        do {
            try thumbnailImageData.write(to: thumbnailImageURL)
            print("🌙 Thumbnail Image Saved")
        } catch let error {
            print(error)
        }
    }
    
    private func createDocumentDirectory(at newDirectory: String) {
        guard let imageWriteDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error locating Directory")
            return
        }
        
        let newDirectoryURL = imageWriteDirectory.appending(component: newDirectory)
        
        if !FileManager.default.fileExists(atPath: newDirectoryURL.path()) {
            print("저장 된 경로 없음 >> 폴더 생성 실시")
            do {
                try FileManager.default.createDirectory(atPath: newDirectoryURL.path(), withIntermediateDirectories: true)
            } catch let error {
                print(error)
            }
        } else {
            print("이미 저장 된 경로 있음 >> 폴더 생성 안함")
        }
    }
    
    private func resizeImageForThumbnail(image: UIImage, cgsize: Int) -> UIImage {
        // Recommended cgsize is around 90.
        let thumbnailSize = CGSize(width: cgsize, height: cgsize)
        let scaledImage = image.scalePreservingAspectRatio(targetSize: thumbnailSize)
        
        return scaledImage
    }
    
    // print("Realm is located at:", realm.configuration.fileURL!)
}

