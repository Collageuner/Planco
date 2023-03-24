//
//  LongTappedDeleteView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/24.
//

import UIKit

import SnapKit
import Then

final class LongTappedPopUpView: UIView {
    private let deleteLabel = UILabel().then {
        $0.textColor = .systemRed
        $0.font = .customVersatileFont(.medium, forTextStyle: .subheadline)
        $0.text = "삭제"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#465E62")
        render()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.borderWidth = 1
    }
    
    private func render() {
        self.addSubview(deleteLabel)
        
        deleteLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
