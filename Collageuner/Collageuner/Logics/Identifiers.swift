//
//  Identifiers.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

enum IdsForCollectionView: String, CaseIterable {
    case StoryCollectionViewId
    case GardenListCollectionViewId
    case PlantsListCollectionViewId
    case PlanItemTableViewId
    
    var identifier: String {
        switch self {
        case .StoryCollectionViewId:
            return "homeStoryIdentifier"
        case .GardenListCollectionViewId:
            return "gardenListIdentifier"
        case .PlantsListCollectionViewId:
            return "plantsListIdentifier"
        case .PlanItemTableViewId:
            return "planItemIdentifier"
        }
    }
}

enum DirectoryForWritingData: String, CaseIterable {
    case TaskOriginalImages
    case TaskThumbnailImages
    case GarageOriginalImages
    case GarageThumbnailImages
    case GardenOriginalImages
    case GardenThumbnailImages
    
    var dataDirectory: String {
        switch self {
        case .TaskOriginalImages:
            return "TaskOriginalImages"
        case .TaskThumbnailImages:
            return "TaskThumbnailImages"
        case .GarageOriginalImages:
            return "GarageOriginalImages"
        case .GarageThumbnailImages:
            return "GarageThumbnailImages"
        case .GardenOriginalImages:
            return "GardenOriginalImages"
        case .GardenThumbnailImages:
            return "GardenThumbnailImages"
        }
    }
}
