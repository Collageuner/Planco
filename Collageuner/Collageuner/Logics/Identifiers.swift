//
//  Identifiers.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

enum IdsForCollectionView: String, CaseIterable {
    case GardenListCollectionViewId
    case PlantsListCollectionViewId
    case MorningPlanItemId
    case EarlyAfternoonPlanItemId
    case LateAfternoonPlanItemId
    case GarageSheetCollectionItemId
    case GarageCollectionItemId
    case GalleryCollectionItemId
    
    var identifier: String {
        switch self {
        case .GardenListCollectionViewId:
            return "gardenList"
        case .PlantsListCollectionViewId:
            return "plantsList"
        case .MorningPlanItemId:
            return "morningPlan"
        case .EarlyAfternoonPlanItemId:
            return "earlyPlan"
        case .LateAfternoonPlanItemId:
            return "latePlan"
        case .GarageSheetCollectionItemId:
            return "garageSheet"
        case .GarageCollectionItemId:
            return "garageList"
        case .GalleryCollectionItemId:
            return "galleryCell"
        }
    }
}

enum IdsForTableView {
    case ProfleTableView
    
    var identifier: String {
        switch self {
        case .ProfleTableView:
            return "profileList"
        }
    }
}

enum DirectoryForWritingData: String, CaseIterable {
    case GarageOriginalImages
    case GarageThumbnailImages
    case TaskOriginalImages
    case TaskThumbnailImages
    case GardenOriginalImages
    case GardenThumbnailImages
    
    var dataDirectory: String {
        switch self {
        case .TaskOriginalImages:
            return "TaskOriginalImage"
        case .TaskThumbnailImages:
            return "TaskThumbnailImage"
        case .GarageOriginalImages:
            return "GarageOriginalImage"
        case .GarageThumbnailImages:
            return "GarageThumbnailImage"
        case .GardenOriginalImages:
            return "GardenOriginalImage"
        case .GardenThumbnailImages:
            return "GardenThumbnailImage"
        }
    }
}

enum SettingConfigurations: String, CaseIterable {
    case GuideBoxChecked
    
    var isChecked: String {
        switch self {
        case .GuideBoxChecked:
            return "guideBox"
        }
    }
}
