//
//  PlanFirstGuideView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/14.
//

import UIKit

import SnapKit
import Then

final class PlanFirstGuideView: UIView {
    private let myTimeZoneGuideLabel = UILabel().then {
        $0.setTextWithLineHeight(text: """
        당신만의 하루를 풀어내어, 정원을 꾸며주세요!
        당신의 오전, 이른 오후, 그리고 늦은 오후는 언제인가요?
        """, lineHeight: 20)
        $0.numberOfLines = 0
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.regualar, forTextStyle: .footnote)
    }
    
    private let myTimeButtonLabel = UILabel().then {
        $0.textColor = .MainGreen
        $0.font = .customVersatileFont(.bold, forTextStyle: .callout)
        $0.text = "나만의 시간 정하기"
    }
    
    private let timeZoneTappedButton = UIImageView().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title3)
        $0.image = UIImage(systemName: "chevron.right.circle.fill", withConfiguration: symbolConfiguration)
        $0.clipsToBounds = true
        $0.tintColor = .MainGreen
    }
    
    private let timeZoneIconButton = UIImageView().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        $0.image = UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration)
        $0.clipsToBounds = true
        $0.tintColor = .PopGreen
    }
    
    private let myGarageImagesGuideLabel = UILabel().then {
        $0.setTextWithLineHeight(text: """
        당신의 정원에는 생김새가 같은 울타리, 잡초, 그리고
        지저귀는 작은 새들이 있을 수 있죠!
        """, lineHeight: 20)
        $0.numberOfLines = 0
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.regualar, forTextStyle: .footnote)
    }
    
    private let myGarageButtonLabel = UILabel().then {
        $0.textColor = .MainGreen
        $0.font = .customVersatileFont(.bold, forTextStyle: .callout)
        $0.text = "자주 쓰는 사진 저장하기"
    }
    
    private let myGarageTappedButton = UIImageView().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title3)
        $0.image = UIImage(systemName: "chevron.right.circle.fill", withConfiguration: symbolConfiguration)
        $0.clipsToBounds = true
        $0.tintColor = .MainGreen
    }
    
    private let myGarageIconButton = UIImageView().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        $0.image = UIImage(systemName: "photo.stack", withConfiguration: symbolConfiguration)
        $0.clipsToBounds = true
        $0.tintColor = .PopGreen
    }
    
    let myTimeZoneStack = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 5
        $0.axis = .horizontal
    }
    
    let myGarageStack = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 5
        $0.axis = .horizontal
    }
    
    lazy var checkedGuideButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .customVersatileFont(.semibold, forTextStyle: .body)
        $0.layer.cornerRadius = 15
        $0.tintColor = UIColor(hex: "#F58C40")
        $0.backgroundColor = UIColor(hex: "#F8DDAE")
        $0.setTitle("확인했어요!", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#FAF1E3")
        updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        myTimeZoneStack.addArrangedSubview(myTimeButtonLabel)
        myTimeZoneStack.addArrangedSubview(timeZoneTappedButton)
        myTimeZoneStack.addArrangedSubview(timeZoneIconButton)
        myGarageStack.addArrangedSubview(myGarageButtonLabel)
        myGarageStack.addArrangedSubview(myGarageTappedButton)
        myGarageStack.addArrangedSubview(myGarageIconButton)
        
        self.addSubviews(myTimeZoneGuideLabel, myTimeZoneStack, myGarageImagesGuideLabel, myGarageStack, checkedGuideButton)
        
        myTimeZoneGuideLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
        }
        
        myTimeZoneStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(myTimeZoneGuideLabel.snp.bottom).offset(5)
        }
        
        myGarageImagesGuideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(myTimeZoneStack.snp.bottom).offset(10)
        }
        
        myGarageStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(myGarageImagesGuideLabel.snp.bottom).offset(5)
        }
        
        checkedGuideButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalToSuperview().dividedBy(1.1)
            $0.height.equalToSuperview().dividedBy(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
