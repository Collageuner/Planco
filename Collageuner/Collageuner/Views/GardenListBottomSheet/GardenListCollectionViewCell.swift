//
//  GardenListCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/11.
//

import UIKit

import SnapKit
import Then

class GardenListCollectionViewCell: UICollectionViewCell {
    
    let gardenCanvasImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubview(gardenCanvasImage)
        
        gardenCanvasImage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
