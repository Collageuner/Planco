//
//  GarageImageSheetViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/27.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

class GarageImageSheetViewController: UIViewController {

    var disposeBag = DisposeBag()
    weak var delegate: GarageSheetDelegate?
    
    private let garageImagesViewModel = GarageImagesViewModel()
    
    private lazy var exitButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    })
    ).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfiguration), for: .normal)
        $0.tintColor = .MainText
    }
    
    private let garageSheetLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.regualar, forTextStyle: .title2)
        $0.text = "My Garage"
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private let imageWhenEmpty = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "PlantListEmpty")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private lazy var garageSheetListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: garageSheetListFlowLayout).then {
        $0.register(GarageSheetCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.GarageSheetCollectionItemId.identifier)
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
    }
    
    private lazy var garageSheetListFlowLayout = UICollectionViewFlowLayout().then {
        let widthSize = Double(view.frame.width - 82)/2
        let heightSize = widthSize
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if garageImagesViewModel.garageImages.value.isEmpty {
            imageWhenEmpty.isHidden = false
        } else {
            imageWhenEmpty.isHidden = true
            imageWhenEmpty.removeFromSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
    }

    private func layouts() {
        view.addSubviews(exitButton, garageSheetLabel, lineDivider, garageSheetListCollectionView, imageWhenEmpty)
        
        exitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35)
            $0.top.equalToSuperview().inset(24)
        }
        
        garageSheetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(35)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(garageSheetLabel.snp.bottom).offset(5)
            $0.height.equalTo(2)
        }
        
        garageSheetListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.top.equalTo(lineDivider.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        imageWhenEmpty.snp.makeConstraints {
            $0.center.equalTo(garageSheetListCollectionView.snp.center)
            $0.width.equalTo(view.snp.width).dividedBy(3)
        }
    }
    
    private func bindings() {
        garageImagesViewModel.garageImages
            .observe(on: MainScheduler.instance)
            .bind(to: garageSheetListCollectionView.rx.items(cellIdentifier: IdsForCollectionView.GarageSheetCollectionItemId.identifier, cellType: GarageSheetCollectionViewCell.self)) { [weak self] index, item, cell in
                let garageImageName = item._id.stringValue
                let thumbnailFetched = self?.garageImagesViewModel.fetchGarageThumbnailImage(id: garageImageName)
                cell.garageImageView.image = thumbnailFetched
            }
            .disposed(by: disposeBag)
        
        garageSheetListCollectionView.rx.modelSelected(GarageImage.self)
            .map { $0._id.stringValue }
            .subscribe { imageId in
                guard let imageName = imageId.element else { return }
                guard let fetchedOriginalImage = self.garageImagesViewModel.fetchGarageOriginalImage(id: imageName) else {
                    print("Error getting original Image for Garage Sheet")
                    return
                }
                
                self.delegate?.fetchImageFromGarage(garageImage: fetchedOriginalImage)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
