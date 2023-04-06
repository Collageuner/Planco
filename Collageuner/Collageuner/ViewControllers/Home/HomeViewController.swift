//
//  ViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 할것 -> enum 으로 내부 Constraints length 한번에 정리해두기!
final class HomeViewController: UIViewController {
    
    // MARK: - Drivers for Live Time Display
    struct LiveTime {
        static let liveMonth = Driver<Int>.interval(.seconds(1)).map { _ in
            return 0
        }
        static let liveDay = Driver<Int>.interval(.seconds(1)).map { _ in
            return 0
        }
    }
    
    // MARK: - Rx Models
    var disposeBag = DisposeBag()
    
    private let gardenCanvasViewModel = GardenCanvasViewModel(currentDate: Date())
    private let taskViewModelStory = TasksViewModel(dateForList: Date())
    
    // MARK: - Time Components
    private lazy var currentMonthLabel = UILabel().then {
        let month = self.dateToMonth(date: Date())
        
        $0.textColor = .SubGreen
        $0.font = .customVersatileFont(.light, forTextStyle: .title1)
        $0.text = "\(month),"
    }
    
    private lazy var currentDayLabel = UILabel().then {
        let day = self.dateToDay(date: Date())
        
        $0.textColor = .SubGreen
        $0.font = .customVersatileFont(.light, forTextStyle: .title2)
        $0.text = day
    }
    
    // MARK: - Garden Canvas Components
    private let mainGardenCanvasView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Plan Blocks Components
    private let planBlockOne = HomePlanBlockView().then {
        $0.backgroundColor = .clear
    }
    
    private let planBlockTwo = HomePlanBlockView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Buttons for Navigation
    /// To Profile
    private lazy var profileButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        let profileViewController = ProfileSettingViewController()
        self?.navigationController?.pushViewController(profileViewController, animated: true)
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "ExampleProfileImage"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .MainGray
    }
    
    /// To Garden of Planning
    private lazy var moveToGardenButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        let planViewController = PlanViewController()
        self?.navigationController?.pushViewController(planViewController, animated: true)
    })
    ).then {
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowColor = UIColor.SubGray.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 2
        $0.setImage(UIImage(named: "ToGardenLogo"), for: .normal)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Other UI Components
    private let appNameLabel = UILabel().then {
        $0.textColor = .PopGreen
        $0.font = .customEnglishFont(.regular, forTextStyle: .largeTitle)
        $0.text = "Planco"
    }
    
    // 얘도 분기처리는 ViewWill 이나 ViewDidAppear 로 처리해야할 듯
    private let notifyingDot = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemRed
        $0.isHidden = false
    }
    
    /// 이건 어떻게 분기처리를 해야할까?
    private let emptyGardenLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .MainGray
        $0.font = .customEnglishFont(.regular, forTextStyle: .title1)
        $0.text = "Fill Your Garden."
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindCanvas()
        bindPlanBlock()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        profileButton.layer.cornerRadius = self.profileButton.frame.width/2
        moveToGardenButton.layer.cornerRadius = self.moveToGardenButton.frame.width/2
        notifyingDot.layer.cornerRadius = self.notifyingDot.frame.width/2
    }
    
    // MARK: - Basic View Configuration
    private func basicSetup() {
        view.backgroundColor = .Background
    }
    
    // MARK: - UI Constraint Layouts
    private func layouts() {
        view.addSubviews(appNameLabel, currentMonthLabel, currentDayLabel, profileButton, notifyingDot, mainGardenCanvasView, emptyGardenLabel, moveToGardenButton, planBlockOne, planBlockTwo)
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        currentMonthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(appNameLabel.snp.bottom).inset(3)
        }
        
        currentDayLabel.snp.makeConstraints {
            $0.leading.equalTo(currentMonthLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(currentMonthLabel.snp.centerY).offset(1.5)
        }
        
        profileButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(currentDayLabel.snp.bottom).inset(3)
            $0.width.height.equalTo(view.snp.width).dividedBy(8)
        }
        
        notifyingDot.snp.makeConstraints {
            $0.centerX.equalTo(profileButton.snp.trailing)
            $0.centerY.equalTo(profileButton.snp.top)
            $0.width.height.equalTo(view.frame.width/68)
        }
        
        mainGardenCanvasView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(currentDayLabel.snp.bottom).offset(view.frame.height/37)
            $0.height.equalTo(mainGardenCanvasView.snp.width).multipliedBy(1.414)
        }
        
        // 분기처리 해야함. 어떤 자료를 기준으로? -> ViewWillAppear 로 애니메이션 넣는걸로 끝내자.
        emptyGardenLabel.snp.makeConstraints {
            $0.center.equalTo(mainGardenCanvasView.snp.center)
        }
        
        moveToGardenButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(mainGardenCanvasView.snp.bottom).offset(30)
            $0.width.height.equalTo(view.snp.height).dividedBy(13)
        }
        
        planBlockOne.snp.makeConstraints {
            $0.top.equalTo(mainGardenCanvasView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(18)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(moveToGardenButton.snp.height).multipliedBy(1.45)
        }
        
        planBlockTwo.snp.makeConstraints {
            $0.top.equalTo(mainGardenCanvasView.snp.bottom).offset(24)
            $0.leading.equalTo(planBlockOne.snp.trailing).offset(8)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(moveToGardenButton.snp.height).multipliedBy(1.45)
        }
    }
    
    // MARK: - Rx Bindings
    private func bindings() {
        LiveTime.liveMonth
            .map { [weak self] _ in
                guard let month = self?.dateToMonth(date: Date()) else { return "" }
                
                return "\(month),"
            }
            .drive(currentMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        LiveTime.liveDay
            .map { [weak self] _ in
                let day = self?.dateToDay(date: Date())
                
                return day
            }
            .drive(currentDayLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 두번씩이나 불러올 필요는 없잖아?
//        gardenCanvasViewModel.currentGardenCanvas
//            .asDriver()
//            .map { [weak self] canvas in
//                let imageName: String = canvas.monthAndYear + "_Canvas"
//                let canvasFetched: UIImage? = self?.loadGardenCanvasFromDirectory(imageName: imageName)
//                return canvasFetched
//            }
//            .drive(mainGardenCanvasView.rx.image)
//            .disposed(by: disposeBag)
    }
}
 
    // MARK: - Other Supplementary Actions
extension HomeViewController {
    private func actions() {
    }
    
    private func bindCanvas() {
        let canvasImage: UIImage = gardenCanvasViewModel.fetchCurrentDateCanvas(currentDate: Date())
        // PDF를 그대로 사용가능한지 테스트함. 가능함
        mainGardenCanvasView.image = UIImage(named: "DefaultCanvasImagePDF")
    }
    
    private func bindPlanBlock() {
        // Closest Task Binding
        taskViewModelStory.filterTaskByCurrentTime(time: Date(), index: 0)
            .bind { [weak self] task in
                guard let cell = task else {
                    self?.planBlockOne.updateToEmptyCell()
                    return
                }
                self?.planBlockOne.updateUIView(cell: cell)
            }
            .disposed(by: disposeBag)
            
        // Second Closest Task Binding
        taskViewModelStory.filterTaskByCurrentTime(time: Date(), index: 1)
            .bind { [weak self] task in
                guard let cell = task else {
                    self?.planBlockTwo.updateToEmptyCell()
                    return
                }
                self?.planBlockTwo.updateUIView(cell: cell)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Date Display Actions
    /// Returns -> Month in short ex) JUL, MAR
    private func dateToMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let monthString = dateFormatter.string(from: date)
        
        return monthString
    }
    
    /// Returns -> Day with "st, nd, Th"
    private func dateToDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dateString = dateFormatter.string(from: date)
        guard let dayInt = Int(dateString) else { return "1st" }
        guard let dayResult = numberFormatter.string(from: NSNumber(value: dayInt)) else { return "2nd" }
        
        return "\(dayResult)"
    }
    
    // MARK: - Fetching Images from Disk
    // Function: Load Thumbnail Image from app disk.
    
    private func loadGardenCanvasFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GardenOriginalImages.dataDirectory) else {
            print("Failed fetching directory for Images for Garden Image")
            return UIImage(named: "DefaultCanvasImage")
        }
        
        let imageURL = thumbnailDirectoryURL.appending(component: "\(imageName).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Garden Canvas Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Images for Garden Image")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "DefaultCanvasImage")
    }
}
