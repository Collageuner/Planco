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
    
//    private let loadingView = AwaitLoadingView().then {
//        $0.backgroundColor = .Background
//        $0.isHidden = true
//    }
    
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
            $0.top.equalTo(lineDivider.snp.bottom).offset(10)
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
            .drive(garageListCollectionView.rx.items(cellIdentifier: IdsForCollectionView.GarageCollectionItemId.identifier, cellType: GarageItemsCollectionViewCell.self)) { [weak self] index, item, cell in
                let garageImageName = item._id.stringValue
                let originalFetched = self?.garageImagesViewModel.fetchGarageOriginalImage(id: garageImageName)
                cell.garageImageView.image = originalFetched?.preparingThumbnail(of: CGSize(width: 400, height: 400))
            }
            .disposed(by: disposeBag)
        
        garageImagesViewModel.garageImages
            .asDriver()
            .map {
                $0.count
            }
            .drive(onNext: { [weak self] in
                switch $0 {
                case 0:
                    self?.imageWhenEmpty.isHidden = false
                default:
                    self?.imageWhenEmpty.isHidden = true
                }
            })
            .disposed(by: DisposeBag())
    }
    
    private func actions() {
        
    }
    
//    private func loadingViewAppear() {
//        loadingView.snp.makeConstraints {
//            $0.top.equalTo(view.snp.top)
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//
//        loadingView.isHidden = false
//    }
//
//    private func loadingViewDisappear() async {
//        loadingView.isHidden = true
//    }
    
    private func navigationItemSetup() {
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(addAssetTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func presentGalleryViewToAdd() {
        DispatchQueue.main.async {
            let galleryVC = GalleryViewController()
            galleryVC.modalPresentationStyle = .overFullScreen
            galleryVC.customNavigationView.setTitleForDoneButtonWith(title: "Next", titleColor: .PopGreen)
            galleryVC.delegate = self
            self.present(galleryVC, animated: true)
        }
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
        print("GarageView Out")
    }
}

extension GarageViewController: GarageViewDelegate {
    func reloadTableViews() {
        garageImagesViewModel.updateGarageImages()
        print("📍📍 Is the CollectionViewReloaded? 📍📍")
    }
}
