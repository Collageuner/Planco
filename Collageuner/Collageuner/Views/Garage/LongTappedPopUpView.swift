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
    private var viewTintColor: UIColor?
    
    private let viewLabel = UILabel().then {
        $0.font = .customVersatileFont(.medium, forTextStyle: .subheadline)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
    }
    
    private func render() {
        self.addSubview(viewLabel)
        
        viewLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setLabel(label: String, color: UIColor) {
        viewTintColor = color
        viewLabel.text = label
        viewLabel.textColor = viewTintColor
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
