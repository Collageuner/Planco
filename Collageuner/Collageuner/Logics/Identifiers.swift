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
    case MorningPlanItemId
    case EarlyAfternoonPlanItemId
    case LateAfternoonPlanItemId
    
    var identifier: String {
        switch self {
        case .StoryCollectionViewId:
            return "homeStory"
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
