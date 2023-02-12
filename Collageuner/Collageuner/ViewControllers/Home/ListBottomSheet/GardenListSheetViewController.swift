//
//  GardenListSheetViewController.swift
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

final class GardenListSheetViewController: UIViewController {

    var disposBag = DisposeBag()
    
    // 얘를 lazy var 로 둬도 되는가?
    private lazy var gardenCanvasViewModel = GardenCanvasViewModel(specificYear: dateToYear(date: Date()))
    
    private lazy var currentYear: BehaviorRelay<String> = BehaviorRelay(value: dateToYear(date: Date()))

    private lazy var exitButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    })
    ).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfiguration), for: .normal)
        $0.tintColor = .MainText
    }
    
    private let gardenSheetLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .customEnglishFont(.regualar, forTextStyle: .title2)
        $0.text = "Gardens of the year"
    }
    
    private lazy var currentYearLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .customEnglishFont(.medium, forTextStyle: .title3)
    }
    
    private lazy var yearMenuDropDown = UIButton(type: .system).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .caption1)
        $0.setImage(UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: symbolConfiguration), for: .normal)
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(identifier: nil, options: .displayInline, children: {
            [weak self] in
            return self?.menuActions ?? [UIAction]()
        }())
        $0.tintColor = .MainGray
        $0.backgroundColor = .clear
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var gardenListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: gardenListFlowLayout).then {
        $0.register(GardenListCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.GardenListCollectionViewId.identifier)
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    private lazy var gardenListFlowLayout = UICollectionViewFlowLayout().then {
        let widthSize = Double(view.frame.width - 86)/3
        let heightSize = widthSize * 1.414
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .vertical
    }
    
    private lazy var menuActions: [UIAction] = [
        UIAction(title: "2023", handler: { [unowned self] _ in
            _ = Observable.just("2023").take(1).bind(to: self.currentYear).disposed(by: self.disposBag)
            self.gardenCanvasViewModel.fetchSpecifirYearsCanvas(specificYear: "2023")
        }),
        UIAction(title: "2024", handler: { [unowned self] _ in
            _ = Observable.just("2024").take(1).bind(to: self.currentYear).disposed(by: self.disposBag)
            self.gardenCanvasViewModel.fetchSpecifirYearsCanvas(specificYear: "2024")
        })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicUI()
        layouts()
        bindings()
        actions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func basicUI() {
        view.backgroundColor = .BottomSheetGreen
    }
    
    private func layouts() {
        view.addSubviews(exitButton, gardenSheetLabel, currentYearLabel, yearMenuDropDown, lineDivider, gardenListCollectionView)
        
        exitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35)
            $0.top.equalToSuperview().inset(24)
        }
        
        gardenSheetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(65)
            $0.leading.equalToSuperview().inset(35)
        }
        
        yearMenuDropDown.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35)
            $0.centerY.equalTo(gardenSheetLabel.snp.centerY)
        }
        
        currentYearLabel.snp.makeConstraints {
            $0.trailing.equalTo(yearMenuDropDown.snp.leading).offset(-5)
            $0.centerY.equalTo(gardenSheetLabel.snp.centerY)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(gardenSheetLabel.snp.bottom).offset(5)
            $0.height.equalTo(2)
        }
        
        gardenListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(lineDivider.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func bindings() {
        currentYear
            .debug()
            .map {String($0)}
            .observe(on: MainScheduler.instance)
            .bind(to: currentYearLabel.rx.text)
            .disposed(by: disposBag)
        
        gardenCanvasViewModel.collectionOfCanvas
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(to: gardenListCollectionView.rx.items(cellIdentifier: IdsForCollectionView.GardenListCollectionViewId.identifier, cellType: GardenListCollectionViewCell.self)) { [weak self] index, garden, cell in
                let gardenImageName = "\(garden.monthAndYear)_Canvas"
                let thumbnailFetched = self?.loadThumbnailImageFromDirectory(imageName: gardenImageName)
                cell.gardenCanvasImage.image = thumbnailFetched
            }
            .disposed(by: disposBag)
        
        gardenListCollectionView.rx.itemSelected
            .subscribe { index in
                print(index)
            }
            .disposed(by: disposBag)
    }
    
    private func actions() {
        
    }
    
    private func loadThumbnailImageFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GardenThumbnailImages.dataDirectory) else {
            print("Failed fetching directory for Thumbnail Images for Garden List")
            return UIImage(named: "DefaultGardenCanvas")
        }
        let imageURL = thumbnailDirectoryURL.appending(component: "Thumbnail_\(imageName).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Thumbnail Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Thumbnail Images for Garden List")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "DefaultGardenCanvas")
    }
    
    /// Returns -> Year in Full ex) 2023, 2024
    private func dateToYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let yearString = dateFormatter.string(from: date)
        
        return yearString
    }
    
    deinit {
        print("deinited - ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
    }
}
