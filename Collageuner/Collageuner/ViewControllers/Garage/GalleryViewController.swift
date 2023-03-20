//
//  GalleryViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/15.
//

import UIKit
import Photos

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class GalleryViewController: UIViewController {
    private let garageViewModel = GarageImagesViewModel()
    private lazy var garageImages: [GarageImage] = garageViewModel.garageImages.value
    
    weak var delegate: GarageViewDelegate?

    private var asset: PHFetchResult<PHAsset>!
    private var selectedAsset: PHAsset! = nil
    private var selectedPngData: Data? = nil

    private let phFetchOptions = PHFetchOptions().then {
        $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    
    private let imageCachingManager = PHCachingImageManager().then {
        $0.allowsCachingHighQualityImages = true
    }
    
    let customNavigationView = ModalCustomBarView()
    
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
    
    private func basicSetup() {
        view.backgroundColor = .black

        initializePHAsset()
        PHPhotoLibrary.shared().register(self)
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
    
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
    
    private func actions() {
        let nextTapped = UITapGestureRecognizer(target: self, action: #selector(moveToConfirm))
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        customNavigationView.doneButton.addGestureRecognizer(nextTapped)
        customNavigationView.cancelButton.addGestureRecognizer(cancelTapped)
    }
        
    private func saveAssetBeforeTap(_ asset: PHAsset) async {
        let imageManager = PHImageManager()
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = false
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageOptions) { [weak self] image, _ in
            self?.selectedPngData = image?.pngData()
        }
        
        
    }
    
    private func passThumbnailImageToGarageViewController(_ asset: PHAsset) {
        let imageManager = PHImageManager()

        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, _ in
            // reloadData Delegate
        }
    }
    
    private func initializePHAsset() {
        asset = PHAsset.fetchAssets(with: .image, options: phFetchOptions)
    }
    
    @objc
    private func moveToConfirm() {
        if selectedAsset != nil {
            Task {
                await saveAssetBeforeTap(selectedAsset)
                
                guard let pngData = selectedPngData else {
                    print("Changing selected PHAsset to png Data Failed")
                    return
                }
                guard let pngImage = UIImage(data: pngData) else { return }
                
                garageViewModel.addGarageImage(garageImage: pngImage)
                self.delegate?.reloadTableViews()
                self.dismiss(animated: true)
            }
        } else {
            print("Nil has been selected")
            self.dismiss(animated: true)
        }
    }
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("GalleryView Out")
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset.count
    }
    
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

extension GalleryViewController: PHPhotoLibraryChangeObserver {
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
