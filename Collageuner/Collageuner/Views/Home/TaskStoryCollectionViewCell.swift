//
//  TaskStoryCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/06.
//

import UIKit

import SnapKit
import Then

final class TaskStoryCollectionViewCell: UICollectionViewCell {
    let taskImage = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFill
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
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.MainGray.cgColor
        self.layer.borderWidth = 3
    }
    
    private func render() {
        self.addSubview(taskImage)
        
        taskImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
