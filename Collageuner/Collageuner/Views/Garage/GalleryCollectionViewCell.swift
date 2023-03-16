//
//  GalleryCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/15.
//

import UIKit

import SnapKit
import Then

class GalleryCollectionViewCell: UICollectionViewCell {
    var representedAssetIdentifier: String?
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func putImageToImageView(_ image: UIImage?) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
