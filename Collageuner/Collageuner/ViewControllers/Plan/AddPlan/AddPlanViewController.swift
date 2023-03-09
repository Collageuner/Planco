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
    
    private let timeZoneTimeLabel = UILabel().then {
        $0.text = ""
        $0.font = .customVersatileFont(.regualar, forTextStyle: .callout)
        $0.textColor = .SubText
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
        $0.returnKeyType = .next
        $0.keyboardType = .default
        $0.font = .customVersatileFont(.bold, forTextStyle: .body)
        $0.textColor = .MainText
        $0.attributedPlaceholder = NSAttributedString(string: " 가장 중요한 일을 적어주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.SubGray.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium)])
    }
    
    private let lineDividerOne = UIView().then {
        $0.backgroundColor = .SubGray.withAlphaComponent(0.8)
    }
    
    private let emotionSectionLabel = UILabel().then {
        $0.text = "🪴 일에 대한 나의 감정"
        $0.font = .customVersatileFont(.semibold, forTextStyle: .title3)
        $0.textColor = .PopGreen
    }
    
    private let emotionTextField = UITextField().then {
        $0.tintColor = .SubGreen
        $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 4))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        $0.keyboardType = .default
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
        $0.attributedPlaceholder = NSAttributedString(string: " 이 일을 생각하면 떠오르는 감정은요?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.SubGray.withAlphaComponent(0.5), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)])
        $0.textColor = .SubText
    }
    
    private let lineDividerTwo = UIView().then {
        $0.backgroundColor = .SubGray.withAlphaComponent(0.5)
    }
    
    private let taskTimeSectionLabel = UILabel().then {
        $0.text = "🕰️ 시작 시간"
        $0.font = .customVersatileFont(.bold, forTextStyle: .title3)
        $0.textColor = .PopGreen
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
    
    private let timeGuideLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .customVersatileFont(.light, forTextStyle: .subheadline)
        $0.textColor = .SubGray.withAlphaComponent(0.7)
        $0.text = "\"시간은 간단한 기준일 뿐이에요.\n 이 시간에 구속되지 않아도 좋아요.\""
    }

    private lazy var decorationImage = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
        $0.image = UIImage(named: fetchImageString())
        $0.contentMode = .scaleAspectFit
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
        mainTaskTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        
        mainTaskTextField.delegate = self
        emotionTextField.delegate = self
    }
    
    private func layouts() {
        view.addSubviews(customNavigationView, timeZoneLabel, timeZoneTimeLabel, mainTaskSectionLabel, mainTaskTextField, lineDividerOne, emotionSectionLabel, emotionTextField, lineDividerTwo, taskTimeSectionLabel, taskTimeDatePicker, timeGuideLabel, decorationImage)
        
        customNavigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15.5)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        timeZoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(customNavigationView.snp.bottom).offset(15)
        }
        
        timeZoneTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(timeZoneLabel.snp.bottom)
        }
        
        mainTaskSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(timeZoneLabel.snp.bottom).offset(60)
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
        
        emotionSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(lineDividerOne.snp.bottom).offset(30)
        }
        
        emotionTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(emotionSectionLabel.snp.bottom).offset(10)
        }
        
        lineDividerTwo.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(emotionTextField.snp.bottom).offset(5)
            $0.height.equalTo(1)
        }
        
        taskTimeSectionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(lineDividerTwo.snp.top).offset(40)
        }
        
        timeGuideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(35)
            $0.top.equalTo(taskTimeSectionLabel.snp.bottom).offset(5)
        }
        
        taskTimeDatePicker.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(taskTimeSectionLabel.snp.centerY)
        }
    
        decorationImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(view.snp.height).dividedBy(3.4)
            $0.width.equalTo(view.snp.width).dividedBy(2.5)
        }
    }
    
    private func bindings() {
        bindTimeLabelFromTimeZone(timeZone: currentTimeZoneString)
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
            
            guard let mainTaskText = mainTaskTextField.text else { return }
            let emotion: String? = emotionTextField.text?.emptyToNil
            
            taskViewModel.createTask(timeZone: currentTimeZoneEnum, taskTime: selectedTaskTime, taskImage: UIImage(), mainTask: mainTaskText, emotion: emotion)
            
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
        switch textField {
        case mainTaskTextField:
            emotionTextField.becomeFirstResponder()
            return true
        case emotionTextField:
            textField.resignFirstResponder()
            return true
        default:
            return true
        }
    }
}
