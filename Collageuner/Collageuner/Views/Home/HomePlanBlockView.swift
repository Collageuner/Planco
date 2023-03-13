//
//  HomePlanBlockView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/08.
//

import UIKit

import SnapKit
import Then

final class HomePlanBlockView: UIView {
    
    private let taskColor: UIColor = .MorningColor

    private lazy var lineDivider = UIView().then {
        $0.backgroundColor = taskColor
    }
    
    private lazy var timeZoneLabel = UILabel().then {
        $0.textColor = taskColor
        $0.numberOfLines = 1
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
    }
    
    private let mainTaskLabel = UILabel().then {
        $0.textColor = .MainText
        $0.numberOfLines = 1
        $0.font = .customVersatileFont(.bold, forTextStyle: .subheadline)
    }
    
    private let taskTimeLabel = UILabel().then {
        $0.textColor = .SubGray
        $0.numberOfLines = 1
        $0.font = .customVersatileFont(.light, forTextStyle: .footnote)
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
        self.addSubviews(lineDivider, timeZoneLabel, mainTaskLabel, taskTimeLabel)
        
        lineDivider.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(3)
        }
        
        timeZoneLabel.snp.makeConstraints {
            $0.top.equalTo(lineDivider.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        mainTaskLabel.snp.makeConstraints {
            $0.top.equalTo(timeZoneLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        taskTimeLabel.snp.makeConstraints {
            $0.top.equalTo(mainTaskLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
    }
    
    func updateUIView(cell: Tasks) {
        let timeStamp: String = cell.taskTime.changeAmPmToString
        let lineColor: String = cell.taskTimeZone
        mainTaskLabel.text = cell.mainTask
        taskTimeLabel.text = timeStamp
        
        switch lineColor {
        case MyTimeZone.morningTime.time:
            lineDivider.backgroundColor = .MorningColor
            timeZoneLabel.text = "오전"
            timeZoneLabel.textColor = .MorningColor
        case MyTimeZone.earlyAfternoonTime.time:
            lineDivider.backgroundColor = .EarlyAfternoonColor
            timeZoneLabel.text = "이른 오후"
            timeZoneLabel.textColor = .EarlyAfternoonColor
        case MyTimeZone.lateAfternoonTime.time:
            lineDivider.backgroundColor = .LateAfternoonColor
            timeZoneLabel.text = "늦은 오후"
            timeZoneLabel.textColor = .LateAfternoonColor
        default:
            return
        }
    }
    
    func updateToEmptyCell() {
        timeZoneLabel.text = "Nothing"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
