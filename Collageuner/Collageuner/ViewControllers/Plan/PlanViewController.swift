//
//  PlanViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import FSCalendar
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PlanViewController: UIViewController {
    
    private lazy var weeklyCalendarView = FSCalendar(frame: .zero).then {
        
        $0.appearance.selectionColor = .MainCalendar
        $0.appearance.todayColor = .MainCalendar.withAlphaComponent(0.5)
        $0.appearance.titleWeekendColor = .SubText
        $0.appearance.weekdayTextColor = .SubGray.withAlphaComponent(0.8)
        $0.appearance.titleFont = .customVersatileFont(.medium, forTextStyle: .subheadline)
        $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 11, weight: .medium)
        $0.locale = Locale(identifier: "en_US")
        $0.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        $0.weekdayHeight = CGFloat(20)
        $0.calendarHeaderView.isHidden = true
        $0.headerHeight = 0
        $0.scrollDirection = .horizontal
        $0.scrollEnabled = true
        $0.scope = .week
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private let guideBox = PlanFirstGuideView().then {
        $0.isHidden = false
    }
    
    private let backgroundPlantImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "BackgroundPlantOne")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
        actions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "photo.stack", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionThree)), UIBarButtonItem(image: UIImage(systemName: "calendar", withConfiguration: symbolConfiguration),  style: .plain, target: self, action: #selector(actionTwo)), UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionOne))]
    }

    private func basicSetup() {
        view.backgroundColor = .Background
        weeklyCalendarView.delegate = self
        weeklyCalendarView.dataSource = self
    }
    
    private func layouts() {
        view.addSubviews(backgroundPlantImage, weeklyCalendarView, lineDivider, guideBox)
        
        backgroundPlantImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
            $0.width.equalToSuperview().dividedBy(2.4)
        }
        
        weeklyCalendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(250)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(weeklyCalendarView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        guideBox.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lineDivider.snp.bottom).offset(15)
            $0.height.equalToSuperview().dividedBy(2.9)
        }
    }
    
    private func bindings() {
    }
    
    private func actions() {
    }
    
    
    
    @objc
    private func actionOne() {
        print("One")
    }
    
    @objc
    private func actionTwo() {
        print("Two")
    }
    
    @objc
    private func actionThree() {
        print("Three")
    }
    
    deinit {
        print("Blue Out")
    }
}

extension PlanViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    
    internal func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PlanViewController_PreViews: PreviewProvider {
    static var previews: some View {
        PlanViewController().toPreview()
    }
}
#endif
