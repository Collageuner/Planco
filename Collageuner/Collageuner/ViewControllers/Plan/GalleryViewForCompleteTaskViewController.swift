//
//  GalleryViewForCompleteTaskController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/26.
//

import UIKit
import Photos

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class GalleryViewForCompleteTaskViewController: UIViewController {
    
    // MARK: - Rx Models
    private let garageViewModel = GarageImagesViewModel()
    
    // MARK: - Custom Delegate for Reloading
    weak var delegate: GarageViewDelegate?

    // MARK: - PHAsset Setup Components
    private var asset: PHFetchResult<PHAsset>!
    private var selectedAsset: PHAsset! = nil
    private var selectedPngData: Data? = nil

    private let phFetchOptions = PHFetchOptions().then {
        $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    
    private let imageCachingManager = PHCachingImageManager().then {
        $0.allowsCachingHighQualityImages = true
    }
    
    // MARK: - Custom Navigation bar
    let customNavigationView = ModalCustomBarView()
    
    // MARK: - CollectionView Components
    private lazy var galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: galleryCollectionViewLayout).then {
        $0.scrollsToTop = true
        $0.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.GalleryCollectionItemId.identifier)
        $0.backgroundColor = .clear
    }
    
    private lazy var galleryCollectionViewLayout = UICollectionViewFlowLayout().then {
        let cellSize = (view.frame.width - 30)/3
        $0.itemSize = CGSize(width: cellSize, height: cellSize)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 5
        $0.scrollDirection = .vertical
    }
    
    // MARK: - Other UI Components
    private let loadingView = AwaitLoadingView().then {
        $0.selectLottieFileName(lottieName: "SavingGarageView")
        $0.isHidden = true
        $0.backgroundColor = .Background
    }
    
    // MARK: - View Cycle 🔄
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Basic View Configuaration
    private func basicSetup() {
        view.backgroundColor = .black

        initializePHAsset()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        // Registering Photo Assets Change Observer
        PHPhotoLibrary.shared().register(self)
    }
    
    // MARK: - UI Constraint Layouts
    private func layouts() {
        view.addSubviews(customNavigationView, galleryCollectionView)
        
        customNavigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15.5)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        galleryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(customNavigationView.snp.bottom).offset(15)
        }
    }
    
    // MARK: - Adding Gesture Recognizer to Buttons
    private func actions() {
        let nextTapped = UITapGestureRecognizer(target: self, action: #selector(moveToConfirm))
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        customNavigationView.doneButton.addGestureRecognizer(nextTapped)
        customNavigationView.cancelButton.addGestureRecognizer(cancelTapped)
    }
     
    // MARK: - Saving Garage Image when Next Button is Tapped
    private func saveAsset(_ asset: PHAsset) async {
        let imageManager = PHImageManager()
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = false
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageOptions) { [weak self] image, info in
            let isDegraged = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
            if isDegraged { return }
            
            let pngData = image?.pngData()
            self?.garageViewModel.addGarageImage(pngGarageData: pngData)
            print("Adding Image to Garage Successed")
            
            self?.delegate?.reloadTableViews()
            self?.dismiss(animated: true)
        }
    }
    
    @objc
    private func moveToConfirm() {
        if selectedAsset != nil {
            loadingViewAppear()
            Task {
                await saveAsset(selectedAsset)
            }
        } else {
            alertWhenNoneIsSelected()
        }
    }
    
    // MARK: - Initializing PHAsset
    private func initializePHAsset() {
        asset = PHAsset.fetchAssets(with: .image, options: phFetchOptions)
    }
    
    // MARK: - Alert action when No Image is selected
    private func alertWhenNoneIsSelected() {
        let alertController = UIAlertController(title: "사진이 선택되지 않았어요.", message: "개러지에 추가할 사진이 선택되지 않았어요.", preferredStyle: .alert)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(hex: "#465E62")
        alertController.view.tintColor = .PopGreen
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Other Stuffs
    /// Loading View Appears
    private func loadingViewAppear() {
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.isHidden = false
        print("LoadingView Appeared")
    }
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Unregister PHAsset Change Observer when deinit
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("GalleryView Out")
    }
}
    // MARK: - Extension for CollectionView Delegate and Datasource
extension GalleryViewForGarageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset.count
    }
    
    /// CollectionView Fetches Thumbnail images
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let thumbnailSize = 300
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdsForCollectionView.GalleryCollectionItemId.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell()}
        let asset = self.asset[indexPath.item]
        cell.representedAssetIdentifier = asset.localIdentifier
        
        imageCachingManager.requestImage(for: asset, targetSize: CGSize(width: thumbnailSize, height: thumbnailSize), contentMode: .aspectFit, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.putImageToImageView(image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.asset[indexPath.item]
        
        selectedAsset = asset
    }
}

    // MARK: - Extension for PHPhotoLibraryChangeObserver
extension GalleryViewForGarageViewController: PHPhotoLibraryChangeObserver {
    /// Now it observes the change of Assets while the app is running
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let assetChanges = changeInstance.changeDetails(for: self.asset) else { return }

        self.asset = assetChanges.fetchResultAfterChanges
        
        if assetChanges.hasIncrementalChanges {
            DispatchQueue.main.async {
                self.galleryCollectionView.performBatchUpdates {
                    if let inserted = assetChanges.insertedIndexes, !inserted.isEmpty {
                        self.galleryCollectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    
                    if let removed = assetChanges.removedIndexes, !removed.isEmpty {
                        self.galleryCollectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                }
            }
        }
    }
}
