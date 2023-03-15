//
//  GarageConfirmViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/14.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class GarageConfirmViewController: UIViewController {
    
    private let garageViewModel = GarageImagesViewModel()
    
    private var selectedImage: UIImage = UIImage()
    
    private let selectedPhotoView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(confirmAssetTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
    }
    
    private func layouts() {
        view.addSubview(selectedPhotoView)
        
        selectedPhotoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(selectedPhotoView.snp.width)
        }
    }

    func passAsset(image: UIImage) {
        selectedImage = image
        selectedPhotoView.image = image.preparingThumbnail(of: CGSize(width: 400, height: 400))
    }
    
    @objc
    private func confirmAssetTapped() {
        garageViewModel.addGarageImage(garageImage: selectedImage)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("garageConfirmView Out")
    }
}
