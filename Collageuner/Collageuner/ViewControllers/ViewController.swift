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
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.semibold, forTextStyle: .largeTitle)
        $0.text = "Oct"
    }
    
    private let currentDayLabel = UILabel().then {
        $0.textColor = .MainText
        $0.font = .customEnglishFont(.medium, forTextStyle: .title2)
        $0.text = "24th"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicUI()
        layouts()
        configurations()
    }
    
    func basicUI() {
        view.backgroundColor = .Background
    }

    func layouts() {
        view.addSubviews(currentMonthLabel, currentDayLabel)
        
        currentMonthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentDayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(self.currentMonthLabel.snp.bottom)
        }
    }
    
    func configurations() {
        
    }

}

