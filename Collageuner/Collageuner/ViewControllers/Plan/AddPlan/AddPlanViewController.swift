//
//  AddPlanViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/23.
//

import UIKit
import PhotosUI

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class AddPlanViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private let timeZoneViewModel = MyTimeZoneViewModel()
    private let taskImageSubject: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    private let taskViewModel = TasksViewModel()
    
    private var currentTimeZoneEnum: MyTimeZone!
    private var currentTimeZoneString: String = ""
    private var currentTimeDay: Date = Date()
    
    private lazy var selectedTaskTime: Date = getMinTime()
    weak var delegate: AddPlanDelegate?
    
    private let customNavigationView = AddPlanCustomBarView()
    
    private lazy var timeZoneLabel = UILabel().then {
        $0.text = fetchTimeZoneLabel()
        $0.font = .customVersatileFont(.bold, forTextStyle: .largeTitle)
        $0.textColor = .MainGreen
    }
    
    private lazy var decorationImage = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
        $0.image = UIImage(named: fetchImageString())
        $0.contentMode = .scaleAspectFit
    }
    
    private let mainTaskSectionLabel = UILabel().then {
        $0.text = "🌿 해야할 일"
        $0.font = .customVersatileFont(.bold, forTextStyle: .title3)
        $0.textColor = .PopGreen
    }
    
    private let mainTaskTextField = UITextField().then {
        $0.tintColor = .SubGreen
        $0.leftView = .init(frame: .init(x: 0, y: 0, width: 5, height: 4))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        $0.keyboardType = .default
        $0.font = .customVersatileFont(.bold, forTextStyle: .body)
        $0.textColor = .MainText
        $0.attributedPlaceholder = NSAttributedString(string: " 가장 중요한 일을 적어주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.SubGray.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium)])
    }
    
    private let lineDividerOne = UIView().then {
        $0.backgroundColor = .SubGray.withAlphaComponent(0.8)
    }
    
    private let subTasksSectionLabel = UILabel().then {
        $0.text = "🌿 세부 항목"
        $0.font = .customVersatileFont(.semibold, forTextStyle: .title3)
        $0.textColor = .PopGreen
    }
    
    private let subTaskTopTextField = UITextField().then {
        $0.tintColor = .SubGreen
        $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 4))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        $0.keyboardType = .default
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
        $0.attributedPlaceholder = NSAttributedString(string: " • 세부 항목은 적어도 좋고,", attributes: [NSAttributedString.Key.foregroundColor : UIColor.SubGray.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)])
        $0.textColor = .SubText
    }
    
    private let lineDividerTwo = UIView().then {
        $0.backgroundColor = .SubGray.withAlphaComponent(0.5)
    }
    
    private let subTaskBottomTextField = UITextField().then {
        $0.tintColor = .SubGreen
        $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 4))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        $0.keyboardType = .default
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
        $0.attributedPlaceholder = NSAttributedString(string: " • 안 적고 넘겨도 좋아요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.SubGray.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)])
        $0.textColor = .SubText
    }
    
    private let lineDividerThree = UIView().then {
        $0.backgroundColor = .SubGray.withAlphaComponent(0.5)
    }
    
    private let taskTimeSectionLabel = UILabel().then {
        $0.text = "🌿 시작 시간"
        $0.font = .customVersatileFont(.bold, forTextStyle: .title3)
        $0.textColor = .PopGreen
    }
    
    private let timeZoneTimeLabel = UILabel().then {
        $0.text = ""
        $0.font = .customVersatileFont(.semibold, forTextStyle: .subheadline)
        $0.textColor = .PopGreen.withAlphaComponent(0.7)
    }
    
    private lazy var taskTimeDatePicker = UIDatePicker().then {
        $0.date = getMinTime()
        $0.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        $0.locale = Locale(identifier: "en_US")
        $0.maximumDate = getMaxTime()
        $0.minimumDate = getMinTime()
        $0.tintColor = .MainCalendar
        $0.minuteInterval = 5
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .compact
    }
    
    private let taskImageSelectSectionLabel = UILabel().then {
        $0.text = "🌿 심을 사진 및 추억"
        $0.font = .customVersatileFont(.bold, forTextStyle: .title3)
        $0.textColor = .MainGreen
    }
    
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
    
    private let loadingView = AwaitLoadingView().then {
        $0.isHidden = true
        $0.backgroundColor = .Background
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        buttonJumpAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        
        mainTaskTextField.delegate = self
        subTaskTopTextField.delegate = self
        subTaskBottomTextField.delegate = self
    }
    
    private func layouts() {
        view.addSubviews(customNavigationView, timeZoneLabel, decorationImage, mainTaskSectionLabel, mainTaskTextField, lineDividerOne, subTasksSectionLabel, subTaskTopTextField, lineDividerTwo, subTaskBottomTextField, lineDividerThree, taskTimeSectionLabel, timeZoneTimeLabel, taskTimeDatePicker, taskImageSelectSectionLabel, assetUsageInfoButton, taskImageSelectedView, defaultTaskImageView, addTaskImageButton)
        
        customNavigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15.5)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        timeZoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(customNavigationView.snp.bottom).offset(15)
        }
        
        decorationImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(timeZoneLabel.snp.top)
            $0.height.equalTo(view.snp.height).dividedBy(11)
            $0.width.equalTo(decorationImage.snp.height).dividedBy(1.4)
        }
        
        mainTaskSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(timeZoneLabel.snp.bottom).offset(50)
        }
        
        mainTaskTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(mainTaskSectionLabel.snp.bottom).offset(10)
        }
        
        lineDividerOne.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(mainTaskTextField.snp.bottom).offset(5)
            $0.height.equalTo(1)
        }
        
        subTasksSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(lineDividerOne.snp.bottom).offset(30)
        }
        
        subTaskTopTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(subTasksSectionLabel.snp.bottom).offset(10)
        }
        
        lineDividerTwo.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(subTaskTopTextField.snp.bottom).offset(5)
            $0.height.equalTo(1)
        }
        
        subTaskBottomTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lineDividerTwo.snp.bottom).offset(10)
        }
        
        lineDividerThree.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(subTaskBottomTextField.snp.bottom).offset(5)
            $0.height.equalTo(1)
        }
        
        taskTimeSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(lineDividerThree.snp.top).offset(50)
        }
        
        taskTimeDatePicker.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(taskTimeSectionLabel.snp.centerY)
        }
        
        timeZoneTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.top.equalTo(taskTimeDatePicker.snp.bottom).offset(5)
        }
        
        taskImageSelectSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(timeZoneTimeLabel.snp.bottom).offset(50)
        }
        
        assetUsageInfoButton.snp.makeConstraints {
            $0.leading.equalTo(taskImageSelectSectionLabel.snp.trailing).offset(10)
            $0.height.equalTo(taskImageSelectSectionLabel.snp.height)
            $0.centerY.equalTo(taskImageSelectSectionLabel.snp.centerY).offset(-1)
        }
        
        addTaskImageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(taskImageSelectSectionLabel.snp.centerY)
        }
        
        taskImageSelectedView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(taskImageSelectSectionLabel.snp.bottom).offset(20)
            $0.height.width.equalTo(view.snp.height).dividedBy(4.7)
        }
        
        defaultTaskImageView.snp.makeConstraints {
            $0.center.equalTo(taskImageSelectedView.snp.center)
            $0.height.equalTo(160)
        }
    }
    
    private func bindings() {
        bindTimeLabelFromTimeZone(timeZone: currentTimeZoneString)
        
        taskImageSubject.asDriver()
            .drive(taskImageSelectedView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func actions() {
        let animationTapped = UITapGestureRecognizer(target: self, action: #selector(self.shakeImageAnimation))
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(cancelAdding))
        let doneTapped = UITapGestureRecognizer(target: self, action: #selector(finishAdding))
        
        decorationImage.addGestureRecognizer(animationTapped)
        customNavigationView.cancelButton.addGestureRecognizer(cancelTapped)
        customNavigationView.doneButton.addGestureRecognizer(doneTapped)
    }
    
    private func getMinTime() -> Date {
        let prefixOfDate: String = Date.prefixOfStringToDate(date: currentTimeDay)
        let suffixOfDateOfMorning: String = timeZoneViewModel.fetchMorningDateComponents().hourToFullHour()
        let suffixOfDateOfEarlyAfternoon: String = timeZoneViewModel.fetchEarlyDateComponents().hourToFullHour()
        let suffixOfDateOfLateAfternoon: String = timeZoneViewModel.fetchLateDateComponents().hourToFullHour()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        let stringDateMorning: String = prefixOfDate + "T" + suffixOfDateOfMorning
        let stringDateEarlyAfternoon: String = prefixOfDate + "T" + suffixOfDateOfEarlyAfternoon
        let stringDateLateAfternoon: String = prefixOfDate + "T" + suffixOfDateOfLateAfternoon
        
        switch currentTimeZoneString {
        case MyTimeZone.morningTime.time:
            return dateFormatter.date(from: stringDateMorning) ?? Date()
        case MyTimeZone.earlyAfternoonTime.time:
            return dateFormatter.date(from: stringDateEarlyAfternoon) ?? Date()
        case MyTimeZone.lateAfternoonTime.time:
            return dateFormatter.date(from: stringDateLateAfternoon) ?? Date()
        default:
            print("Time Wrong!")
            return Date()
        }
    }
    
    private func getMaxTime() -> Date {
        let prefixOfDate: String = Date.prefixOfStringToDate(date: currentTimeDay)
        let suffixOfDateOfEarlyAfternoon: String = timeZoneViewModel.fetchEarlyDateComponents().hourToFullHour()
        let suffixOfDateOfLateAfternoon: String = timeZoneViewModel.fetchLateDateComponents().hourToFullHour()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current

        let stringDateEarlyAfternoon: String = prefixOfDate + "T" + suffixOfDateOfEarlyAfternoon
        let stringDateLateAfternoon: String = prefixOfDate + "T" + suffixOfDateOfLateAfternoon
        let stringDateMidnight: String = prefixOfDate + "T23:59:59"
        
        switch currentTimeZoneString {
        case MyTimeZone.morningTime.time:
            return dateFormatter.date(from: stringDateEarlyAfternoon) ?? Date()
        case MyTimeZone.earlyAfternoonTime.time:
            return dateFormatter.date(from: stringDateLateAfternoon) ?? Date()
        case MyTimeZone.lateAfternoonTime.time:
            return dateFormatter.date(from: stringDateMidnight) ?? Date()
        default:
            print("Time Wrong!!")
            return Date()
        }
    }
    
    private func fetchTimeZoneLabel() -> String {
        switch currentTimeZoneString {
        case MyTimeZone.morningTime.time:
            return "나의 오전"
        case MyTimeZone.earlyAfternoonTime.time:
            return "나의 이른 오후"
        case MyTimeZone.lateAfternoonTime.time:
            return "나의 늦은 오후"
        default:
            return ""
        }
    }
    
    private func fetchImageString() -> String {
        switch currentTimeZoneString {
        case MyTimeZone.morningTime.time:
            return "morningPlant.png"
        case MyTimeZone.earlyAfternoonTime.time:
            return "earlyPlant.png"
        case MyTimeZone.lateAfternoonTime.time:
            return "latePlant.png"
        default:
            return ""
        }
    }
    
    private func assetUsageInfoAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            print("QUESTION MARK!")
            // 안내 페이지 On
        }
        
        return action
    }
    
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
    
    private func bindTimeLabelFromTimeZone(timeZone: String) {
        let timeLabelDriver: Driver<String>
        
        switch timeZone {
        case MyTimeZone.morningTime.time:
            timeLabelDriver = timeZoneViewModel.morningTimeZone.asDriver()
        case MyTimeZone.earlyAfternoonTime.time:
            timeLabelDriver = timeZoneViewModel.earlyAfternoonTimeZone.asDriver()
        case MyTimeZone.lateAfternoonTime.time:
            timeLabelDriver = timeZoneViewModel.lateAfternoonTimeZone.asDriver()
        default:
            print("Error getting proper time label")
            return
        }
        
        timeLabelDriver
            .drive(timeZoneTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func navigationItemSetup() {
        navigationItem.hidesBackButton = true
        navigationController?.setToolbarHidden(false, animated: true)
        let rightBarDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishAdding))
        let backBarCancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAdding))
        rightBarDoneButton.tintColor = .PopGreen
        navigationItem.setLeftBarButton(backBarCancelButton, animated: true)
        navigationItem.setRightBarButton(rightBarDoneButton, animated: true)
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
    
    private func mainTextFieldAnimationWhenEmpty() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 4, -10, 10, -4, 0]
        animation.keyTimes = [0, 0.07, 0.15, 0.25, 0.32, 0.4]
        animation.duration = 0.4
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        mainTaskTextField.layer.add(animation, forKey: nil)
    }
    
    @objc
    private func shakeImageAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.values = [0, -15, -5, -13, 0]
        animation.keyTimes = [0, 0.08, 0.15, 0.22, 0.35]
        animation.duration = 0.35
        animation.fillMode = .backwards
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        decorationImage.layer.add(animation, forKey: nil)
    }
    
    @objc
    private func didSelectDate() {
        selectedTaskTime = taskTimeDatePicker.date
        print(selectedTaskTime)
    }
    
    @objc
    private func cancelAdding() {
        self.dismiss(animated: true)
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
    
    private func loadingViewAppear() {
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.dismiss(animated: true)
        }
    }
    
    deinit {
        print("AddPlanView Out")
    }
}

extension AddPlanViewController {
    func changeCurrentTimeZone(timeZone: MyTimeZone) {
        switch timeZone {
        case .morningTime:
            currentTimeZoneEnum = timeZone
            currentTimeZoneString = timeZone.time
        case .earlyAfternoonTime:
            currentTimeZoneEnum = timeZone
            currentTimeZoneString = timeZone.time
        case .lateAfternoonTime:
            currentTimeZoneEnum = timeZone
            currentTimeZoneString = timeZone.time
        }
    }
    
    func changeCurrentDate(date: Date) {
        currentTimeDay = date
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddPlanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
