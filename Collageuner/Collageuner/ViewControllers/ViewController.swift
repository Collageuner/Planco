//
//  ViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

    private let currentMonthLabel = UILabel().then {
        $0.font = .customEnglishFont(.semibold, forTextStyle: .largeTitle)
        $0.text = "Oct"
    }
    
    private let currentDayLabel = UILabel().then {
        $0.font = .customEnglishFont(.medium, forTextStyle: .title2)
        $0.text = "24th"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layouts()
    }

    func layouts() {
        view.addSubviews(currentMonthLabel, currentDayLabel)
        
        currentMonthLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        currentDayLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY).offset(30)
        }
    }

}

