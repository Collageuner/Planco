//
//  ViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/06.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 할것 -> enum 으로 내부 Constraints length 한번에 정리해두기!

final class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
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
    
    private let profileButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("Adidas AddTarget!") // Navigation 으로 넘어가야 함
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "ExampleProfileImage.png"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .MainGray
    }
    
    private var notifyingDot = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemRed
        $0.isHidden = false
    }
    
//    private let plansStoryCollectionView = UICollectionView().then {}
    
    private let mainGardenImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 4
        $0.image = UIImage(named: "ExampleGardenImage.png")
        $0.clipsToBounds = true
    }
    
    private let gardenListButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("🏡 Open Half Sheet of a Garden List")
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "GardenListLogo"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private let plantsListButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("🌲 Open Half Sheet of a Plants List")
    })
    ).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "PlantsListLogo"), for: .normal)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private let moveToGardenButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("To Garden!")
    })
    ).then {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfiguration), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicUI()
        layouts()
        configurations()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        profileButton.layer.cornerRadius = self.profileButton.frame.width/2
        gardenListButton.layer.cornerRadius = self.gardenListButton.frame.width/2
        moveToGardenButton.layer.cornerRadius = self.moveToGardenButton.frame.width/2
        notifyingDot.layer.cornerRadius = self.notifyingDot.frame.width/2
    }
    
    private func basicUI() {
        view.backgroundColor = .Background
    }

    private func layouts() {
        view.addSubviews(currentMonthLabel, currentDayLabel, profileButton, notifyingDot, mainGardenImageView, gardenListButton, plantsListButton, moveToGardenButton)
        
        currentMonthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentDayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(self.currentMonthLabel.snp.bottom)
        }
        
        profileButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.currentDayLabel.snp.bottom).inset(5)
            $0.width.height.equalTo(view.snp.width).dividedBy(9)
        }
        
        notifyingDot.snp.makeConstraints {
            $0.centerX.equalTo(self.profileButton.snp.trailing)
            $0.centerY.equalTo(self.profileButton.snp.top)
            $0.width.height.equalTo(view.frame.width/65.5)
        }
        
        mainGardenImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.currentDayLabel.snp.bottom).offset(view.frame.height/10.65)
            $0.height.equalTo(self.mainGardenImageView.snp.width).multipliedBy(1.414)
        }
        
        gardenListButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(view.snp.width).dividedBy(6.1)
        }
        
        plantsListButton.snp.makeConstraints {
            $0.leading.equalTo(self.gardenListButton.snp.trailing).offset(15)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(self.gardenListButton.snp.width)
        }
        
        moveToGardenButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(self.mainGardenImageView.snp.bottom).offset(20)
            $0.width.height.equalTo(self.gardenListButton.snp.width)
        }
    }
    
    private func configurations() {
        
    }
    
    private func actions() {
        
    }

}

