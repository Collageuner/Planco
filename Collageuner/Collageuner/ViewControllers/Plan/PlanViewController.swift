//
//  PlanViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import FSCalendar
import RealmSwift
import RxDataSources
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PlanViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    private lazy var morningPlanTableViewHeight: CGFloat = cellHeight * CGFloat(morningTasks.value.count)
    
    private lazy var earlyAfternoonPlanTableViewHeight: CGFloat = cellHeight * CGFloat(earlyAfternoonTasks.value.count)
    
    private lazy var lateAfternoonPlanTableViewHeight: CGFloat = cellHeight * CGFloat(lateAfternoonTasks.value.count)
    
    private lazy var cellHeight: CGFloat = view.frame.height/11.1
    private lazy var sectionHeight: CGFloat = view.frame.height/21
    private var currentDate: Date = Date()
    
    private var guideTapped = BehaviorRelay(value: UserDefaults.standard.bool(forKey: "isGuideBoxTapped"))
    
    private lazy var taskViewModel = TasksViewModel(dateForList: currentDate)
    private let plansViewModel = PlansTableItemViewModel()
    
    private lazy var weeklyCalendarView = FSCalendar(frame: .zero).then {
        $0.appearance.selectionColor = .MainCalendar
        $0.appearance.todayColor = .MainCalendar.withAlphaComponent(0.5)
        $0.appearance.titleWeekendColor = .SubText
        $0.appearance.weekdayTextColor = .SubGray.withAlphaComponent(0.8)
        $0.appearance.titleFont = .customVersatileFont(.medium, forTextStyle: .callout)
        $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.locale = Locale(identifier: "en_US")
        $0.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        $0.weekdayHeight = CGFloat(22)
        $0.calendarHeaderView.isHidden = true
        $0.headerHeight = 2
        $0.scrollDirection = .horizontal
        $0.scrollEnabled = true
        $0.scope = .week
    }
    
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private let guideBox = PlanFirstGuideView(frame: .zero)
    
    private let morningSectionView = PlanTimeSectionHeaderView().then {
        $0.planTimeZoneLabel.text = "오전"
        $0.backgroundColor = .MorningColor
    }
    
    private let earlyAfternoonSectionView = PlanTimeSectionHeaderView().then {
        $0.planTimeZoneLabel.text = "이른 오후"
        $0.backgroundColor = .EarlyAfternoonColor
    }
    
    private let lateAfternoonSectionView = PlanTimeSectionHeaderView().then {
        $0.planTimeZoneLabel.text = "늦은 오후"
        $0.backgroundColor = .LateAfternoonColor
    }
    
    private let morningPlanTableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.MorningPlanItemId.identifier)
    }
    
    private let earlyAfternoonPlanTableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.EarlyAfternoonPlanItemId.identifier)
    }
    
    private let lateAfternoonPlanTableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.LateAfternoonPlanItemId.identifier)
    }
    
    private lazy var morningTasks = plansViewModel.fetchPlansForTableView(timeZone: .morningTime, date: currentDate)
    private lazy var earlyAfternoonTasks = plansViewModel.fetchPlansForTableView(timeZone: .earlyAfternoonTime, date: currentDate)
    private lazy var lateAfternoonTasks = plansViewModel.fetchPlansForTableView(timeZone: .lateAfternoonTime, date: currentDate)
    
    private let backgroundPlantImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "BackgroundPlantOne")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        taskViewModel.createTask(timeZone: .morningTime, taskTime: currentDate, taskImage: UIImage(named: "tempLogo"), mainTask: "그냥 명상하기", subTasks: ["다른 생각 진짜 하지 않기!"])
//        taskViewModel.createTask(timeZone: .morningTime, taskTime: Date(timeIntervalSinceNow: 1000), taskImage: UIImage(named: "ExampleProfileImage"), mainTask: "떡볶이 먹기", subTasks: ["엽떡!!!! 끄아앙아ㅡ아ㅡ아아아ㅡ아으ㅏ앙앙", "움ㄴ냠ㄴ누ㅑㅁㅁ냠ㅁ냠"])
//        taskViewModel.createTask(timeZone: .earlyAfternoonTime, taskTime: Date(timeIntervalSinceNow: 2000), taskImage: UIImage(named: "GardenListLogo"), mainTask: "낮잠 절대로 참기! 절대로 절대로!!!!!!", subTasks: ["기타치기", "끼얏호"])
//        taskViewModel.createTask(timeZone: .earlyAfternoonTime, taskTime: Date(timeIntervalSinceNow: 2500), taskImage: UIImage(named: "GardenListLogo"), mainTask: "낮잠 절대 절대로!!!!!!", subTasks: ["기타치기", "끼얏호"])
//        taskViewModel.createTask(timeZone: .lateAfternoonTime, taskTime: Date(timeIntervalSinceNow: 5000), taskImage: UIImage(named: "G4"), mainTask: "저녁은 샐러드로!", subTasks: ["엽! 끄아앙아ㅡ아ㅡ아아아ㅡ아으ㅏ앙앙", "움ㄴ냠ㄴ누ㅑㅁㅁ냠ㅁ냠"])
//        taskViewModel.createTask(timeZone: .lateAfternoonTime, taskTime: Date(timeIntervalSinceNow: 6000), taskImage: UIImage(named: "G4"), mainTask: "저녁은 샐러드로!", subTasks: ["엽떡!!!! 끄아앙아ㅡ아ㅡ아아아ㅡ아으ㅏ앙앙", "움ㄴ냠ㄴ누ㅑㅁㅁ냠ㅁ냠"])
        basicSetup()
        layouts()
        bindings()
        actions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionThree)), UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock", withConfiguration: symbolConfiguration),  style: .plain, target: self, action: #selector(actionTwo)), UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionOne))]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func basicSetup() {
        view.backgroundColor = .Background
        
        weeklyCalendarView.delegate = self
        weeklyCalendarView.dataSource = self
        
        morningPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
        earlyAfternoonPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
        lateAfternoonPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func layouts() {
        view.addSubviews(backgroundPlantImage, weeklyCalendarView, lineDivider, morningSectionView, morningPlanTableView, earlyAfternoonSectionView, earlyAfternoonPlanTableView, lateAfternoonSectionView, lateAfternoonPlanTableView)
        
        backgroundPlantImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
            $0.width.equalToSuperview().dividedBy(2.4)
        }
        
        weeklyCalendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(250)
        }
        
        lineDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(weeklyCalendarView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        morningSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lineDivider.snp.bottom).offset(15)
            $0.height.equalTo(sectionHeight)
        }
        
        morningPlanTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(morningSectionView.snp.bottom).offset(5)
            $0.height.equalTo(morningPlanTableViewHeight)
        }
        
        earlyAfternoonSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(morningPlanTableView.snp.bottom).offset(5)
            $0.height.equalTo(sectionHeight)
        }
        
        earlyAfternoonPlanTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(earlyAfternoonSectionView.snp.bottom).offset(5)
            $0.height.equalTo(earlyAfternoonPlanTableViewHeight)
        }
        
        lateAfternoonSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(earlyAfternoonPlanTableView.snp.bottom).offset(5)
            $0.height.equalTo(sectionHeight)
        }

        lateAfternoonPlanTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lateAfternoonSectionView.snp.bottom).offset(5)
            $0.height.equalTo(lateAfternoonPlanTableViewHeight)
        }
    }
    
    private func bindings() {
        morningTasks.asDriver()
            .distinctUntilChanged()
            .drive(morningPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.MorningPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task)
            }
            .disposed(by: disposeBag)
        
        earlyAfternoonTasks.asDriver()
            .distinctUntilChanged()
            .drive(earlyAfternoonPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.EarlyAfternoonPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task)
            }
            .disposed(by: disposeBag)
        
        lateAfternoonTasks.asDriver()
            .distinctUntilChanged()
            .drive(lateAfternoonPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.LateAfternoonPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    /// Rx 로 못 바꿀까?
    private func updateTableHeight() {
        morningPlanTableViewHeight = cellHeight * CGFloat(morningTasks.value.count)
    
        earlyAfternoonPlanTableViewHeight = cellHeight * CGFloat(earlyAfternoonTasks.value.count)
    
        lateAfternoonPlanTableViewHeight = cellHeight * CGFloat(lateAfternoonTasks.value.count)
        
        morningPlanTableView.snp.updateConstraints {
            $0.height.equalTo(morningPlanTableViewHeight)
        }
        
        earlyAfternoonPlanTableView.snp.updateConstraints {
            $0.height.equalTo(earlyAfternoonPlanTableViewHeight)
        }
        
        lateAfternoonPlanTableView.snp.updateConstraints {
            $0.height.equalTo(lateAfternoonPlanTableViewHeight)
        }
    }
    
    private func actions() {
    }
    
    @objc
    private func actionOne() {
    }
    
    @objc
    private func actionTwo() {
    }
    
    @objc
    private func actionThree() {
    }
    
    deinit {
        print("Blue Out")
    }
}

extension PlanViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDate = date
        plansViewModel.updateTableView(date: currentDate)
        updateTableHeight()
    }
    
    internal func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}

extension PlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PlanItemTableViewCell else { return UISwipeActionsConfiguration() }
        
        let isExpired = cell.fetchIsExpired()
        let isCompleted = cell.fetchIsCompleted()
                
        if isExpired == true || isCompleted == true {
            cell.isUserInteractionEnabled = false
            print("Working")
            return UISwipeActionsConfiguration()
        }
        
        let cellId = cell.fetchCellTaskId()

        let checkAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.plansViewModel.updatePlanCompleted(id: cellId)
            
            tableView.reloadRows(at: [indexPath], with: .right)
            
            print("Not Working")
            completionHandler(true)
        }

        checkAction.backgroundColor = .Background
        checkAction.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))?.withTintColor(.PopGreen, renderingMode: .alwaysOriginal)

        let configuration = UISwipeActionsConfiguration(actions: [checkAction])

        return configuration
    }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct PlanViewController_PreViews: PreviewProvider {
//    static var previews: some View {
//        PlanViewController().toPreview()
//    }
//}
//#endif
