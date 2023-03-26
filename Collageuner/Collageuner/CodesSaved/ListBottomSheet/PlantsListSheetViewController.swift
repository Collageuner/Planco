//
//  PlantsListSheetViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/11.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PlantsListSheetViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    private lazy var taskListViewModel = TasksViewModel(dateForMonthList: curentMonth)
    
    lazy var curentMonth = Date()
    
    private lazy var exitButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    })
    ).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfiguration), for: .normal)
        $0.tintColor = .MainText
    }
    
    private let plantsSheetLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.regular, forTextStyle: .title2)
        $0.text = "Your Plants"
    }
    
    private let imageWhenEmpty = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "PlantListEmpty")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private lazy var plantsListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: plantsListFlowLayout).then {
        $0.register(PlantsListCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.PlantsListCollectionViewId.identifier)
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
    }
    
    private lazy var plantsListFlowLayout = UICollectionViewFlowLayout().then {
        let widthSize = Double(view.frame.width - 82)/2
        let heightSize = widthSize * 0.3
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 10
        $0.scrollDirection = .vertical
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
        if taskListViewModel.taskListForMonth.value.isEmpty {
            imageWhenEmpty.isHidden = false
        } else {
            imageWhenEmpty.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
    }
    
    private func layouts() {
        view.addSubviews(exitButton, plantsSheetLabel, lineDivider, plantsListCollectionView, imageWhenEmpty)
        
        exitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35)
            $0.top.equalToSuperview().inset(24)
        }
        
        plantsSheetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(35)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(plantsSheetLabel.snp.bottom).offset(5)
            $0.height.equalTo(2)
        }
        
        plantsListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(lineDivider.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        imageWhenEmpty.snp.makeConstraints {
            $0.center.equalTo(plantsListCollectionView.snp.center)
            $0.width.equalTo(view.snp.width).dividedBy(3)
        }
    }
    
    private func bindings() {
        taskListViewModel.taskListForMonth
            .observe(on: MainScheduler.instance)
            .bind(to: plantsListCollectionView.rx.items(cellIdentifier: IdsForCollectionView.PlantsListCollectionViewId.identifier, cellType: PlantsListCollectionViewCell.self)) { [weak self] index, task, cell in
                let plantImageName = task.taskTime + task._id.stringValue
                let thumbnailFetched = self?.loadThumbnailImageFromDirectory(imageName: plantImageName)
                var timeModified = task.keyForDayCheck
                timeModified.insert("/", at: timeModified.index(timeModified.startIndex, offsetBy: 4))
                timeModified.insert("/", at: timeModified.index(timeModified.startIndex, offsetBy: 2))
                
                cell.plantImage.image = thumbnailFetched
                cell.plantedDate.text = timeModified
                cell.plantedTask.text = task.mainTask
            }
            .disposed(by: disposeBag)
    }
    
    private func actions() {
        
    }
    
    private func loadThumbnailImageFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.TaskThumbnailImages.dataDirectory) else {
            print("Failed fetching directory for Thumbnail Images for Plants List")
            return UIImage(named: "TaskDefaultImage")
        }
        let imageURL = thumbnailDirectoryURL.appending(component: "Thumbnail_\(imageName).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Thumbnail Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Thumbnail Images for Plant List")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "TaskDefaultImage")
    }
    
    deinit {
        print("deinited - ⚠️⚠️🥕🥕🥕🥕⚠️⚠️⚠️")
    }
}
