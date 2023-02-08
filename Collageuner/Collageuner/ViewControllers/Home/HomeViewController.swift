//
//  ViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 할것 -> enum 으로 내부 Constraints length 한번에 정리해두기!

final class HomeViewController: UIViewController {
    var notificationTokent: NotificationToken?
    
    var disposeBag = DisposeBag()
    
    let timeViewModel = MyTimeZoneViewModel()
    let taskViewModel = TasksViewModel(dateForList: Date())
    let taskViewModelStory = TasksViewModel(dateForStories: Date())
    
    private let currentMonthLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.semibold, forTextStyle: .largeTitle)
        $0.text = "Oct"
    }
    
    private let currentDayLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.medium, forTextStyle: .title2)
        $0.text = "24th"
    }
    
    private lazy var profileButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        self.timeViewModel.saveTimeZone(zoneTime: Date(timeIntervalSinceNow: -20000), timeZone: .morningTime)
        self.timeViewModel.saveTimeZone(zoneTime: Date.now, timeZone: .earlyAfternoonTime)
        self.timeViewModel.saveTimeZone(zoneTime: Date(timeIntervalSinceNow: 10000), timeZone: .lateAfternoonTime)
        print("ProfileButton Tapped!") // Navigation 으로 넘어가야 함
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "ExampleProfileImage.png"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .MainGray
    }
    
    private var notifyingDot = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemRed
        $0.isHidden = false
    }
    
    /// CollectionView
    private lazy var taskStoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: storyFlowLayout).then {
        $0.register(TaskStoryCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.storyCollectionViewId.identifier)
    }
    
    private let mainGardenImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 4
        $0.image = UIImage(named: "ExampleGardenImage.png")
        $0.clipsToBounds = true
    }
    
    private lazy var gardenListButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        self.timeViewModel.updateTimeZone(zoneTime: Date(timeIntervalSinceNow: -20000), timeZone: .morningTime)
        self.timeViewModel.updateTimeZone(zoneTime: Date.now, timeZone: .earlyAfternoonTime)
        self.timeViewModel.updateTimeZone(zoneTime: Date(timeIntervalSinceNow: 10000), timeZone: .lateAfternoonTime)
        print(self.timeViewModel.mytimeRealm.objects(MyTimeZoneString.self))
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "GardenListLogo"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private lazy var plantsListButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        let nextVC = TestttViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        print("🌲 Open Half Sheet of a Plants List")
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "PlantsListLogo"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private lazy var moveToGardenButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("To Garden!")
    })
    ).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfiguration), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 3
    }
    
    /// CollectionView
    private lazy var storyFlowLayout = UICollectionViewFlowLayout().then {
        let itemSizes = Double(self.view.frame.width - 30)/6
        $0.itemSize = CGSize(width: itemSizes, height: itemSizes)
        $0.minimumInteritemSpacing = 5
        $0.scrollDirection = .horizontal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicUI()
        layouts()
        bindings()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        notifyToken()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        notificationTokent?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        profileButton.layer.cornerRadius = self.profileButton.frame.width/2
        gardenListButton.layer.cornerRadius = self.gardenListButton.frame.width/2
        moveToGardenButton.layer.cornerRadius = self.moveToGardenButton.frame.width/2
        notifyingDot.layer.cornerRadius = self.notifyingDot.frame.width/2
    }
    
    private func basicUI() {
//        taskViewModel.createTask(timeZone: MyTimeZone.morningTime.rawValue, taskTime: Date(), taskImage: "", mainTask: "떡국 먹고 한살 더 먹기", subTasks: ["test3", "test22"], taskExpiredCheck: false, taskCompleted: false)
        
//        taskViewModel.saveImageToDocumentDirectory(imageName: "testImage3", image: UIImage(named: "ExampleProfileImage.png") ?? UIImage(systemName: "xmark.seal")!)
//        for _ in 0...1 {
//            taskViewModelStory.createTask(timeZone: MyTimeZone.morningTime.rawValue, taskTime: Date(), taskImage: <#T##String?#>, mainTask: <#T##String#>, subTasks: <#T##[String?]#>, taskExpiredCheck: <#T##Bool#>)
//        }
        
        view.backgroundColor = .Background
    }

    private func layouts() {
        view.addSubviews(currentMonthLabel, currentDayLabel, profileButton, notifyingDot, taskStoryCollectionView, mainGardenImageView, gardenListButton, plantsListButton, moveToGardenButton)
        
        currentMonthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentDayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(self.currentMonthLabel.snp.bottom)
        }
        
        profileButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.currentDayLabel.snp.bottom).inset(5)
            $0.width.height.equalTo(view.snp.width).dividedBy(9)
        }
        
        notifyingDot.snp.makeConstraints {
            $0.centerX.equalTo(self.profileButton.snp.trailing)
            $0.centerY.equalTo(self.profileButton.snp.top)
            $0.width.height.equalTo(view.frame.width/65.5)
        }
        
        /// CollectionView
        taskStoryCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(self.view.snp.height).dividedBy(15.8)
        }
        
        mainGardenImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.currentDayLabel.snp.bottom).offset(view.frame.height/10.65)
            $0.height.equalTo(self.mainGardenImageView.snp.width).multipliedBy(1.414)
        }
        
        gardenListButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(view.snp.width).dividedBy(6.1)
        }
        
        plantsListButton.snp.makeConstraints {
            $0.leading.equalTo(self.gardenListButton.snp.trailing).offset(15)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(self.gardenListButton.snp.width)
        }
        
        moveToGardenButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(self.gardenListButton.snp.width)
        }
    }
    
    private func bindings() {
        timeViewModel.morningTimeZone
            .observe(on: MainScheduler.instance)
            .bind(to: currentMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        timeViewModel.earlyAfternoonTimeZone
            .observe(on: MainScheduler.instance)
            .bind(to: currentDayLabel.rx.text)
            .disposed(by: disposeBag)
        
        /// CollectionView
        taskViewModelStory.taskList
            .observe(on: MainScheduler.instance)
            .bind(to: taskStoryCollectionView.rx.items(cellIdentifier: IdsForCollectionView.storyCollectionViewId.identifier, cellType: TaskStoryCollectionViewCell.self)) { index, task, cell in
                let thumbnailName: String = task._id.stringValue + task.keyForDateCheck
                let thumbnailFetched = self.loadThumbnailImageFromDirectory(imageName: thumbnailName)
                cell.taskImage.image = thumbnailFetched
            }
            .disposed(by: disposeBag)
        
        taskStoryCollectionView.rx.itemSelected
            .subscribe { index in
                print(index)
            }
            .disposed(by: disposeBag)
    }
    
    private func actions() {
        
    }
    
    private func loadThumbnailImageFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.ThumbnailImages.dataDirectory) else {
            print("Failed fetching directory for Thumbnail Images for Home-Stories")
            return UIImage(named: "TaskDefaultImage")
        }
        let imageURL = thumbnailDirectoryURL.appending(component: imageName)
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Thumbnail Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Thumbnail Images for Home-Stories")
            print(error)
        }
        
        print("RRRRTTTT FAILED!")
        return UIImage(named: "TaskDefaultImage")
    }
    
    private func notifyToken() {
        let tokenRealm = timeViewModel.mytimeRealm.objects(MyTimeZoneString.self)

        notificationTokent = tokenRealm.observe { change in
            switch change {
            case .initial:
                print("Token Initialized")
            case .update(_, _, _, _):
                let newTimeViewModel = MyTimeZoneViewModel()
                newTimeViewModel.morningTimeZone
                    .observe(on: MainScheduler.instance)
                    .bind(to: self.currentMonthLabel.rx.text)
                    .disposed(by: self.disposeBag)
                newTimeViewModel.earlyAfternoonTimeZone
                    .observe(on: MainScheduler.instance)
                    .bind(to: self.currentDayLabel.rx.text)
                    .disposed(by: self.disposeBag)
                print("Modified Token")
            case .error(let error):
                print("Error in \(error)")
            }
        }
        
        print("Notifying Token Opened.")
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}
