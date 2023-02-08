//
//  UIImage+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/04.
//

import UIKit

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)

        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

/*   ⚠️ USAGE
     let thumbnailSize = CGSize(width: 80, height: 80)
     let scaledImage = image.scalePreservingAspectRatio(targetSize: thumbnailSize)
 
     ...
 
     guard let thumbnailImageData = scaledImage.pngData() else {
         print("Failed to Compress Image into thumbnail Image")
         return
     }
 */
