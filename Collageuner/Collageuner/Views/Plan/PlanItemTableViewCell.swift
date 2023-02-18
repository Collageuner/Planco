//
//  PlanItemCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class PlanItemCollectionViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private var planCheckedToDone: Bool = false {
        didSet {
            switch planCheckedToDone {
            case true:
                self.layer.opacity = 0.6
            default:
                self.layer.opacity = 1.0
            }
        }
    }
    
    let taskImage = UIImageView().then {
        $0.backgroundColor = .Background
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let mainTaskLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .MainText
        $0.font = .customVersatileFont(.bold, forTextStyle: .subheadline)
    }
    
    let subTasksLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.regualar, forTextStyle: .footnote)
    }
    
    let taskTimeLabel = UILabel().then {
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        taskImage.clipsToBounds = true
        taskImage.layer.cornerRadius = self.taskImage.frame.height/2
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
    }
    
    private func render() {
        self.addSubviews(taskImage, mainTaskLabel, taskTimeLabel, subTasksLabel)
        
        taskImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(self.snp.height).dividedBy(1.27)
            $0.centerY.equalToSuperview()
        }
        
        mainTaskLabel.snp.makeConstraints {
            $0.leading.equalTo(taskImage.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(self.frame.height/9.5)
            $0.width.equalToSuperview().dividedBy(1.63)
        }
        
        taskTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(mainTaskLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        subTasksLabel.snp.makeConstraints {
            $0.leading.equalTo(mainTaskLabel.snp.leading)
            $0.top.equalTo(mainTaskLabel.snp.bottom).offset(3)
            $0.width.equalToSuperview().dividedBy(1.63)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
