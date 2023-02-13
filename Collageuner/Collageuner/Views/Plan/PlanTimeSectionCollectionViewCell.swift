//
//  PlanTimeSectionCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import SnapKit
import Then

final class PlanTimeSectionCollectionViewCell: UICollectionViewCell {
    
    let planTimeZoneLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
    }
    
    let addTappedButton = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.tintColor = .white
        $0.image = UIImage(systemName: "plus.circle.fill")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func render() {
        self.addSubviews(planTimeZoneLabel, addTappedButton)
        
        planTimeZoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        addTappedButton.snp.makeConstraints {
            $0.height.equalToSuperview().dividedBy(1.6)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
