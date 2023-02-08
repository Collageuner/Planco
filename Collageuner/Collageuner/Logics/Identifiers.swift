//
//  Identifiers.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

enum IdsForCollectionView: String, CaseIterable {
    case storyCollectionViewId
    
    var identifier: String {
        switch self {
        case .storyCollectionViewId:
            return "homeStoryIdentifier"
        }
    }
}

enum DirectoryForWritingData: String, CaseIterable {
    case OriginalImages
    case ThumbnailImages
    
    var dataDirectory: String {
        switch self {
        case .OriginalImages:
            return "OriginalImages"
        case .ThumbnailImages:
            return "ThumbnailImages"
        }
    }
}
