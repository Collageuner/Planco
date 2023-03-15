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
    private lazy var galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: galleryCollectionViewLayout).then {
        $0.scrollsToTop = true
        $0.register(GardenListCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.GardenListCollectionViewId.identifier)
        $0.backgroundColor = .red
    }
    
    private lazy var galleryCollectionViewLayout = UICollectionViewFlowLayout().then {
        let cellSize = (view.frame.width - 20)/3
        $0.itemSize = CGSize(width: cellSize, height: cellSize)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
        $0.scrollDirection = .vertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
    }
    
    private func basicSetup() {
        
    }
    
    private func layouts() {
        
    }
    
    private func bindings() {
        
    }
}
