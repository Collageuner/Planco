//
//  ProfileSettingTableViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import SnapKit
import Then

final class ProfileSettingTableViewCell: UITableViewCell {
    private let symbolImageView = UIImageView().then {
        $0.tintColor = .LateAfternoonColor
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let profileMenuLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customVersatileFont(.regular, forTextStyle: .body)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        render()
    }
    
    private func render() {
        self.addSubviews(symbolImageView, profileMenuLabel)
        
        symbolImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
            $0.width.height.equalTo(self.snp.height).dividedBy(2.5)
        }
        
        profileMenuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileSettingTableViewCell {
    func setCellUI(menu: String, symbol: String) {
        symbolImageView.image = UIImage(systemName: symbol)
        profileMenuLabel.text = menu
    }
}
