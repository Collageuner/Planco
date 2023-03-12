//
//  PlanTimeSectionHeaderView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class PlanTimeSectionHeaderView: UIView {
    
    var disposeBag = DisposeBag()
    
    let planTimeZoneLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
    }
    
    let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubviews(planTimeZoneLabel, lineDivider)
        
        planTimeZoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
