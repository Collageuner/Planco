//
//  GarageSheetCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/27.
//

import UIKit

final class GarageSheetCollectionViewCell: UICollectionViewCell {
    
    let garageImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        garageImageView.clipsToBounds = true
        garageImageView.layer.cornerRadius = 15
    }
    
    private func render() {
        self.addSubview(garageImageView)
        
        garageImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("GarageSheetOut")
    }
}
