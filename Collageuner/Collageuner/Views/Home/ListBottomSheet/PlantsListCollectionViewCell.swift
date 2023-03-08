//
//  PlantsListCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/11.
//

import UIKit

import SnapKit
import Then

final class PlantsListCollectionViewCell: UICollectionViewCell {
    
    let plantImage = UIImageView().then {
        $0.backgroundColor = .MainGray
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFill
    }
    
    let plantedDate = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customVersatileFont(.regualar, forTextStyle: .caption1)
    }
    
    let plantedTask = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .MainText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
    }
    
    private let textStackView = UIStackView().then {
        $0.spacing = 2
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }
    
    private let cellStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plantImage.clipsToBounds = true
        plantImage.layer.cornerRadius = 15
    }
    
    private func render() {
        textStackView.addArrangedSubview(plantedDate)
        textStackView.addArrangedSubview(plantedTask)
        cellStackView.addArrangedSubview(plantImage)
        cellStackView.addArrangedSubview(textStackView)
        
        self.addSubview(cellStackView)
        
        cellStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        plantImage.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(self.snp.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
