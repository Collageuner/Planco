//
//  ImageCacheManager.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/20.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
