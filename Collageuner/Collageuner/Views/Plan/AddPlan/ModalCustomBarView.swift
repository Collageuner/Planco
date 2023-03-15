//
//  ModoalCustomBarView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/23.
//

import UIKit

import SnapKit
import Then

final class ModalCustomBarView: UIView {
    var doneOrNextLabel: String = "Done"
    
    let cancelButton = UIButton(type: .system).then {
        $0.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font : UIFont.customVersatileFont(.regular, forTextStyle: .headline) ?? UIFont.preferredFont(forTextStyle: .title3, weight: .medium)]), for: .normal)
        $0.tintColor = .gray
    }
    
    lazy var doneButton = UIButton(type: .system).then {
        $0.setAttributedTitle(NSAttributedString(string: doneOrNextLabel, attributes: [NSAttributedString.Key.font : UIFont.customVersatileFont(.medium, forTextStyle: .headline) ?? UIFont.preferredFont(forTextStyle: .title3, weight: .medium)]), for: .normal)
        $0.tintColor = .MainGreen
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
    
    private func render() {
        self.addSubviews(cancelButton, doneButton)
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
