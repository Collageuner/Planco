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
        $0.tintColor = .SubGray
    }
    
    lazy var doneButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        updateConstraints()
        setTitleForDoneButtonWith()
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
    
    /// Default Button title is "Done". It can be changed with a new title and a new button tint color.
    func setTitleForDoneButtonWith(title: String = "Done", titleColor: UIColor = .MainGreen) {
        doneButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.customVersatileFont(.semibold, forTextStyle: .headline) ?? UIFont.preferredFont(forTextStyle: .title3, weight: .medium)]), for: .normal)
        doneButton.tintColor = titleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
