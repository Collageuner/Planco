//
//  GarageViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/14.
//

import UIKit
import Photos

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class GarageViewController: UIViewController {
    private let cache = ImageCacheManager.shared
    private var currentLongPressedCell: GarageItemsCollectionViewCell?
    
    var disposeBag = DisposeBag()
    
    private let garageImagesViewModel = GarageImagesViewModel()
    
    private let garageLabel = UILabel().then {
        $0.font = .customEnglishFont(.regular, forTextStyle: .title1)
        $0.textColor = .PopGreen
        $0.text = "My Garage"
    }
    
    private let garageGuideLabel = UILabel().then {
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
        $0.textColor = .SubGray
        $0.text = "자주 사용할 이미지를 최대 20개까지 저장 가능해요.\n길게 누르면 수정할 수 있어요!"
        $0.numberOfLines = 2
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private var imageWhenEmpty = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "PlantListEmptyLight")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private lazy var garageListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: garageListFlowLayout).then {
        $0.bounces = false
        $0.register(GarageItemsCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.GarageCollectionItemId.identifier)
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
    }
    
    private lazy var garageListFlowLayout = UICollectionViewFlowLayout().then {
        let widthSize = Double(view.frame.width - 82)/2
        let heightSize = widthSize
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 10
        $0.scrollDirection = .vertical
    }
    
    private let deletePopUpView = LongTappedPopUpView().then {
        $0.setLabel(label: "삭제", color: .systemRed)
        $0.setBackgroundColor(color: .white)
    }
    
    private let okPopUpView = LongTappedPopUpView().then {
        $0.setLabel(label: "완료", color: .PopGreen)
        $0.setBackgroundColor(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        actions()
        bindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        setupLongGestureRecognizerOnCollectionVew()
    }

    private func layouts() {
        view.addSubviews(garageLabel, garageGuideLabel, lineDivider, garageListCollectionView, imageWhenEmpty)
        
        garageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        
        garageGuideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(garageLabel.snp.bottom).offset(5)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(garageGuideLabel.snp.bottom).offset(16)
            $0.height.equalTo(1)
        }
        
        garageListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lineDivider.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        imageWhenEmpty.snp.makeConstraints {
            $0.centerX.equalTo(garageListCollectionView.snp.centerX)
            $0.centerY.equalTo(garageListCollectionView.snp.centerY).offset(-40)
            $0.height.width.equalTo(250)
        }
    }
    
    private func bindings() {
        garageImagesViewModel.garageImages
            .asDriver()
            .drive(garageListCollectionView.rx.items(cellIdentifier: IdsForCollectionView.GarageCollectionItemId.identifier, cellType: GarageItemsCollectionViewCell.self)) { index, item, cell in
                let garageObjectId = item._id
                let garageImageName = item._id.stringValue
                let garageCacheKey = NSString(string: garageImageName)
                
                if let cachedImage = self.cache.object(forKey: garageCacheKey) {
                    cell.garageImageView.image = cachedImage
                    cell.putIdToCell(id: garageObjectId)
                } else {
                    guard let thumbnailFetched = self.garageImagesViewModel.fetchGarageThumbnailImage(id: garageImageName) else { return }
                    cell.garageImageView.image = thumbnailFetched
                    cell.putIdToCell(id: garageObjectId)

                    self.cache.setObject(thumbnailFetched, forKey: garageCacheKey)
                }
            }
            .disposed(by: disposeBag)
        
        garageImagesViewModel.garageImages
            .asDriver()
            .drive(onNext: { [weak self] in
                switch $0.isEmpty {
                case true:
                    self?.imageWhenEmpty.isHidden = false
                case false:
                    self?.imageWhenEmpty.isHidden = true
                }
            })
            .disposed(by: DisposeBag())
    }
    
    private func actions() {
        let deleteTapped = UITapGestureRecognizer(target: self, action: #selector(deleteViewTapped))
        let okTapped = UITapGestureRecognizer(target: self, action: #selector(okViewTapped))
        deletePopUpView.addGestureRecognizer(deleteTapped)
        okPopUpView.addGestureRecognizer(okTapped)
    }
    
    @objc
    private func addAssetTapped() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite){
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized, .limited:
                    self.presentGalleryViewToAdd()
                case .denied:
                    self.moveToSettingView()
                default:
                    print("")
                }
            }
        case .restricted:
            print("Restricted")
        case .denied:
            self.moveToSettingView()
        case .authorized, .limited:
            self.presentGalleryViewToAdd()
        default:
            print("")
        }
    }
    
    deinit {
        print("📍📍📍GarageView Out📍📍📍")
    }
}

extension GarageViewController {
    private func navigationItemSetup() {
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(addAssetTapped))
        navigationItem.rightBarButtonItem?.tintColor = .PopGreen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func startShakingCellLongTapped(cell: UICollectionViewCell) {
        let editingAnimation = CAKeyframeAnimation(keyPath: "position.y")
        editingAnimation.values = [0, -10, -1, -6, -3, 0]
        editingAnimation.keyTimes = [0, 0.4, 0.5, 0.59, 0.65, 0.7]
        editingAnimation.duration = 0.7
        editingAnimation.repeatCount = .infinity
        editingAnimation.fillMode = .forwards
        editingAnimation.isRemovedOnCompletion = false
        editingAnimation.isAdditive = true
        cell.layer.add(editingAnimation, forKey: "jumpUntilDone")
    }
    
    private func finishShakingCellLongTapped(cell: UICollectionViewCell?) {
        cell?.layer.removeAllAnimations()
    }
    
    private func deleteViewAppear(cell: GarageItemsCollectionViewCell) {
        deletePopUpView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        okPopUpView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        view.addSubviews(deletePopUpView, okPopUpView)
        
        deletePopUpView.snp.makeConstraints {
            $0.centerX.equalTo(cell.snp.trailing).offset(-20)
            $0.centerY.equalTo(cell.snp.top).offset(10)
            $0.height.equalTo(35)
            $0.width.equalTo(55)
        }
        
        okPopUpView.snp.makeConstraints {
            $0.centerX.equalTo(cell.snp.trailing).offset(-20)
            $0.centerY.equalTo(cell.snp.top).offset(50)
            $0.height.equalTo(35)
            $0.width.equalTo(55)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0) {
            self.deletePopUpView.transform = .identity
            self.okPopUpView.transform = .identity
        }
    }
    
    private func popUpViewDisappear() {
        deletePopUpView.removeFromSuperview()
        okPopUpView.removeFromSuperview()
    }
    
    private func disableViewTouch() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        garageListCollectionView.isUserInteractionEnabled = false
        print("CollectionView Touch Disabled")
    }
    
    private func enableViewTouch() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        garageListCollectionView.isUserInteractionEnabled = true
        print("CollectionView Touch Enabled")
    }
    
    @objc
    private func deleteViewTapped() {
        deleteSelectedImage(cell: currentLongPressedCell)
        finishShakingCellLongTapped(cell: currentLongPressedCell)
        popUpViewDisappear()
        enableViewTouch()
    }
    
    @objc
    private func okViewTapped() {
        finishShakingCellLongTapped(cell: currentLongPressedCell)
        popUpViewDisappear()
        enableViewTouch()
    }
    
    private func deleteSelectedImage(cell: GarageItemsCollectionViewCell?) {
        guard let cellId = cell?.fetchCellId() else { return }
        garageImagesViewModel.deleteGarageImage(garageImageId: cellId)
        garageImagesViewModel.updateGarageImages()
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func presentGalleryViewToAdd() {
        let garageItems: Int = garageImagesViewModel.garageImages.value.count
        
        if garageItems < 20 {
            DispatchQueue.main.async {
                let galleryVC = GalleryViewController()
                galleryVC.modalPresentationStyle = .overFullScreen
                galleryVC.customNavigationView.setTitleForDoneButtonWith(title: "Next", titleColor: .PopGreen)
                galleryVC.delegate = self
                self.present(galleryVC, animated: true)
            }
        } else {
            alertWhenGarageIsFull()
        }
    }
    
    private func alertWhenGarageIsFull() {
        let alertController = UIAlertController(title: "추가 실패", message: "개러지에 저장된 이미지가 제한 개수를 넘었어요!", preferredStyle: .alert)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(hex: "#465E62")
        alertController.view.tintColor = .PopGreen
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func moveToSettingView() {
        let alertController = UIAlertController(title: "권한 거부됨", message: "앨범 접근이 거부 되었습니다. 개러지에 사진을 넣을 수 없어요.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: false, completion: nil)
        }
    }
}

extension GarageViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollectionVew() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressEditCollectionView(gestureRecognizer: )))
        longPressGesture.minimumPressDuration = 0.4
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        garageListCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func longPressEditCollectionView(gestureRecognizer: UILongPressGestureRecognizer) {
        let tappedLocation: CGPoint = gestureRecognizer.location(in: garageListCollectionView)
        
        if gestureRecognizer.state == .began {
            if let indexPath = garageListCollectionView.indexPathForItem(at: tappedLocation) {
                UIView.animate(withDuration: 0.2) {
                    guard let cell = self.garageListCollectionView.cellForItem(at: indexPath) as? GarageItemsCollectionViewCell else {
                        return
                    }
                    
                    self.currentLongPressedCell = cell
                    cell.transform = .init(scaleX: 0.9, y: 0.9)
                }
            }
        } else if gestureRecognizer.state == .ended {
            if let indexPath = garageListCollectionView.indexPathForItem(at: tappedLocation) {
                guard let cell = self.garageListCollectionView.cellForItem(at: indexPath) as? GarageItemsCollectionViewCell else {
                    return
                }
                
                disableViewTouch()
                
                self.currentLongPressedCell = cell
                cell.transform = .init(scaleX: 1.0, y: 1.0)
                
                startShakingCellLongTapped(cell: cell)
                self.deleteViewAppear(cell: cell)
            }
        } else {
            return
        }
    }
}

extension GarageViewController: GarageViewDelegate {
    func reloadTableViews() {
        garageImagesViewModel.updateGarageImages()
        imageWhenEmpty.isHidden = true
    }
}
