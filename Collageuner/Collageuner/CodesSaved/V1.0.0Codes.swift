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

// MARK: - Photo Selection
/*
 
 class VIEWCONTROLLER {
 
     private let taskImageSubject: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
 

     private lazy var assetUsageInfoButton = UIButton(type: .system, primaryAction: assetUsageInfoAction()).then {
         $0.tintColor = .MainCalendar.withAlphaComponent(0.5)
         let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
         $0.setImage(UIImage(systemName: "questionmark.circle.fill", withConfiguration: symbolConfiguration), for: .normal)
     }
 
     private let taskImageSelectedView = UIImageView().then {
         $0.contentMode = .scaleAspectFit
         $0.backgroundColor = .clear
     }
     
     private let defaultTaskImageView: LottieAnimationView = .init(name: "EmptyPlanTaskImage").then {
         $0.contentMode = .scaleAspectFit
         $0.animationSpeed = 1.8
         $0.loopMode = .loop
         $0.play()
     }
 
     private lazy var addTaskImageButton = UIButton(type: .system).then {
         $0.layer.shadowOpacity = 0.5
         $0.layer.shadowOffset = CGSize(width: 1, height: 1)
         $0.layer.shadowRadius = 1.2
         $0.layer.shadowColor = UIColor.white.cgColor
         let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
         $0.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfiguration), for: .normal)
         $0.tintColor = .PopGreen
         $0.showsMenuAsPrimaryAction = true
         $0.menu = UIMenu(identifier: nil, options: .displayInline, children: { [weak self] in
             return self?.getMenuActionForImage() ?? [UIAction]()
         }())
     }
 
     function 대충 binding 에 들어감
     taskImageSubject.asDriver()
         .drive(taskImageSelectedView.rx.image)
         .disposed(by: disposeBag)
 
     private func openPHPicker() {
         var phpickerConfiguration = PHPickerConfiguration()
         phpickerConfiguration.selectionLimit = 1
         phpickerConfiguration.filter = .images
         let imagePicker = PHPickerViewController(configuration: phpickerConfiguration)
         imagePicker.delegate = self
         
         self.present(imagePicker, animated: true)
     }
 
     private func openGarageBottomSheet() {
         let garageBottomSheet = GarageImageSheetViewController()
         garageBottomSheet.delegate = self
         garageBottomSheet.modalPresentationStyle = .pageSheet

         if let sheet = garageBottomSheet.sheetPresentationController {
             sheet.prefersGrabberVisible = true
             sheet.preferredCornerRadius = 30
             sheet.detents = [
                 .custom { context in
                     return context.maximumDetentValue * 0.7
                 }
             ]
         }
         self.present(garageBottomSheet, animated: true)
     }
 
     @objc
     private func finishAdding() {
         let mainTaskisNilorEmpty = mainTaskTextField.text.isNilorEmpty
         switch mainTaskisNilorEmpty {
         case true:
             mainTextFieldAnimationWhenEmpty()
         case false:
             view.endEditing(true)
             
             let taskImage: UIImage = taskImageSubject.value
             guard let mainTaskText = mainTaskTextField.text else { return }
             let subTasks: [String?] = [subTaskTopTextField.text?.emptyToNil, subTaskBottomTextField.text?.emptyToNil]
             
             taskViewModel.createTask(timeZone: currentTimeZoneEnum, taskTime: selectedTaskTime, taskImage: taskImage, mainTask: mainTaskText, subTasks: subTasks)
             
             self.delegate?.reloadTableViews()
             
             loadingViewAppear()
         }
     }
 
     private func getMenuActionForImage() -> [UIAction] {
         let menuActions: [UIAction] = [
             UIAction(title: "개러지에서 가져오기", image: UIImage(systemName: "photo.on.rectangle.angled"), handler: { [unowned self] _ in
                 self.openGarageBottomSheet()
             }),
             UIAction(title: "앨범에서 가져오기",image: UIImage(named: "ApplePhotoAlbumLogo.png"), handler: { [unowned self] _ in
                 self.openPHPicker()
             })
         ]
         
         return menuActions
     }
 
     private func buttonJumpAnimation() {
         let animation = CAKeyframeAnimation(keyPath: "position.y")
         animation.values = [0, -12, 0, 4, -5, 0, 0]
         animation.keyTimes = [0, 0.25, 0.35, 0.4, 0.45, 0.5, 0.7]
         animation.duration = 0.7
         animation.repeatCount = 2
         animation.fillMode = .forwards
         animation.isRemovedOnCompletion = false
         animation.isAdditive = true
         addTaskImageButton.layer.add(animation, forKey: nil)
     }
 
 }
 
 extension AddPlanViewController: PHPickerViewControllerDelegate {
     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         
         picker.dismiss(animated: true)
         
         guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
             print("Error Fetching Data From PHPicker")
             return
         }
         
         itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] taskImage, error in
             
             // 여기서 Navigation 으로 넘어가서 crop 할 수 있는 기능을 넣자.
             // 그러면 VC 가 달라질테니 ViewModel 로 하나 만들어서 편하게 통일 시켜야겠네.
             
             Observable<UIImage>.create { emitter in
                 guard let selectedImage = taskImage as? UIImage else {
                     print("Error Changing into Data.")
                     return Disposables.create()}
                 let pngImage = selectedImage
                 
                 emitter.onNext(pngImage)
                 emitter.onCompleted()
                 
                 return Disposables.create()
             }
             .bind(to: self.taskImageSubject)
             .disposed(by: self.disposeBag)
         }
         
         self.defaultTaskImageView.isHidden = true
     }
 }

 extension AddPlanViewController: GarageSheetDelegate {
     func fetchImageFromGarage(garageImage: UIImage) {
         Observable.just(garageImage)
             .bind(to: self.taskImageSubject)
             .disposed(by: disposeBag)
         
         defaultTaskImageView.isHidden = true
     }
 }
 
 */

// MARK: - Reload TableView
/*
 
 somewhere.... +
  nextAddPlanView.delegate = self
 
 extension PlanViewController: AddPlanDelegate {
     func reloadTableViews() {
         plansViewModel.updateTableView(date: currentDate)
         updateTableHeight()
         updateSectionView()
     }
 }
 
 
 */
