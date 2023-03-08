//
//  V1.0.0Codes.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/08.
//


/// To Garden List of the year
/*
 
 private lazy var gardenListButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
     let gardenBottomSheet = GardenListSheetViewController()
     gardenBottomSheet.modalPresentationStyle = .pageSheet
     if let sheet = gardenBottomSheet.sheetPresentationController {
         sheet.prefersGrabberVisible = true
         sheet.preferredCornerRadius = 30
         sheet.detents = [
             .custom { context in
                 return context.maximumDetentValue * 0.98
             }
         ]
     }
     self?.present(gardenBottomSheet, animated: true, completion: nil)
 })
 ).then {
     $0.contentMode = .scaleAspectFill
     $0.setImage(UIImage(named: "GardenListLogo"), for: .normal)
     $0.layer.masksToBounds = true
     $0.clipsToBounds = true
 }
 
 */

/// To Plant List of the month
/*
 
 private lazy var plantsListButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
     let plantsBottomSheet = PlantsListSheetViewController()
     plantsBottomSheet.modalPresentationStyle = .pageSheet
     if let sheet = plantsBottomSheet.sheetPresentationController {
         sheet.prefersScrollingExpandsWhenScrolledToEdge = false
         sheet.prefersGrabberVisible = true
         sheet.preferredCornerRadius = 30
         sheet.detents = [
             .custom { context in
                 return context.maximumDetentValue * 0.6
             },
             .custom { context in
                 return context.maximumDetentValue * 0.9
             }
         ]
     }
     self?.present(plantsBottomSheet, animated: true, completion: nil)
 })
 ).then {
     $0.contentMode = .scaleAspectFill
     $0.setImage(UIImage(named: "PlantsListLogo"), for: .normal)
     $0.layer.masksToBounds = true
     $0.clipsToBounds = true
 }
 
 */

// MARK: - Lottie Components
/*
 
 private let defaultStoryImage: LottieAnimationView = .init(name: "EmptyHome").then {
     $0.layer.cornerRadius = 5
     $0.contentMode = .scaleAspectFill
     $0.play()
     $0.clipsToBounds = true
     $0.animationSpeed = 1.0
     $0.loopMode = .loop
 }
 
 */

