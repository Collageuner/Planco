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
    
    // MARK: - UI Size Components
    private lazy var morningPlanTableViewHeight: CGFloat = cellHeight * CGFloat(morningTasks.value.count)
    private lazy var earlyAfternoonPlanTableViewHeight: CGFloat = cellHeight * CGFloat(earlyAfternoonTasks.value.count)
    private lazy var lateAfternoonPlanTableViewHeight: CGFloat = cellHeight * CGFloat(lateAfternoonTasks.value.count)
    
    private lazy var cellHeight: CGFloat = view.frame.height/10.9
    private lazy var sectionHeight: CGFloat = view.frame.height/19
    private var currentDate: Date = Date()
    
    // MARK: - Rx Models
    var disposeBag = DisposeBag()
    
    private lazy var taskViewModel = TasksViewModel(dateForList: currentDate)
    private let plansViewModel = PlansTableItemViewModel()
    
    private lazy var morningTasks = plansViewModel.fetchPlansForTableView(timeZone: .morningTime, date: currentDate)
    private lazy var morningTasksCount = plansViewModel.fetchCountOfPlans(timeZone: .morningTime)
    
    private lazy var earlyAfternoonTasks = plansViewModel.fetchPlansForTableView(timeZone: .earlyAfternoonTime, date: currentDate)
    private lazy var earlyAfternoonTasksCount = plansViewModel.fetchCountOfPlans(timeZone: .earlyAfternoonTime)
    
    private lazy var lateAfternoonTasks = plansViewModel.fetchPlansForTableView(timeZone: .lateAfternoonTime, date: currentDate)
    private lazy var lateAfternoonTasksCount = plansViewModel.fetchCountOfPlans(timeZone: .lateAfternoonTime)
    
    // MARK: - Calendar Components
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
    
    // MARK: - Section Components
    private lazy var morningSectionView = PlanTimeSectionHeaderView().then {
        $0.addTappedButton.isUserInteractionEnabled = true
        $0.planTimeZoneLabel.text = "오전"
        $0.backgroundColor = .MorningColor
    }
    
    private lazy var earlyAfternoonSectionView = PlanTimeSectionHeaderView().then {
        $0.addTappedButton.isUserInteractionEnabled = true
        $0.planTimeZoneLabel.text = "이른 오후"
        $0.backgroundColor = .EarlyAfternoonColor
    }
    
    private lazy var lateAfternoonSectionView = PlanTimeSectionHeaderView().then {
        $0.addTappedButton.isUserInteractionEnabled = true
        $0.planTimeZoneLabel.text = "늦은 오후"
        $0.backgroundColor = .LateAfternoonColor
    }
    
    // MARK: - TableView Components
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
    
    // MARK: - Other UI Components
    private let lineDivider = UIView().then {
        $0.backgroundColor = .MainGray
    }
    
    private let backgroundPlantImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "BackgroundPlantOne")
        $0.contentMode = .scaleAspectFit
    }
    
    private let guideBox = PlanFirstGuideView(frame: .zero).then {
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.isHidden = true
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
        actions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
        guideBoxSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Basic View Configuaration
    private func basicSetup() {
        view.backgroundColor = .Background
        
        weeklyCalendarView.delegate = self
        weeklyCalendarView.dataSource = self
        
        morningPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
        earlyAfternoonPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
        lateAfternoonPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - UI Constraint Layouts
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
            $0.top.equalTo(morningPlanTableView.snp.bottom).offset(8)
            $0.height.equalTo(sectionHeight)
        }
        
        earlyAfternoonPlanTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(earlyAfternoonSectionView.snp.bottom).offset(5)
            $0.height.equalTo(earlyAfternoonPlanTableViewHeight)
        }
        
        lateAfternoonSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(earlyAfternoonPlanTableView.snp.bottom).offset(8)
            $0.height.equalTo(sectionHeight)
        }
        
        lateAfternoonPlanTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(lateAfternoonSectionView.snp.bottom).offset(5)
            $0.height.equalTo(lateAfternoonPlanTableViewHeight)
        }
    }
    
    // MARK: - Rx Bindings
    private func bindings() {
        /// Morning List
        morningTasks.asDriver()
            .drive(morningPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.MorningPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task) }
            .disposed(by: disposeBag)
        
        morningTasksCount.asDriver()
            .map {
                switch $0 {
                case 2: return true
                default: return false }
            }
            .drive(morningSectionView.addTappedButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        /// EarlyAfternoon List
        earlyAfternoonTasks.asDriver()
            .drive(earlyAfternoonPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.EarlyAfternoonPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task) }
            .disposed(by: disposeBag)
        
        earlyAfternoonTasksCount.asDriver()
            .map {
                switch $0 {
                case 2: return true
                default: return false }
            }
            .drive(earlyAfternoonSectionView.addTappedButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        /// LateAfternoon List
        lateAfternoonTasks.asDriver()
            .drive(lateAfternoonPlanTableView.rx.items(cellIdentifier: IdsForCollectionView.LateAfternoonPlanItemId.identifier, cellType: PlanItemTableViewCell.self)) { row, task, cell in
                cell.updateUICell(cell: task) }
            .disposed(by: disposeBag)
        
        lateAfternoonTasksCount.asDriver()
            .map {
                switch $0 {
                case 2: return true
                default: return false }
            }
            .drive(lateAfternoonSectionView.addTappedButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Updating Table height Action
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
    
    private func updateSectionView() {
        plansViewModel.updatePlanCounts(morningCount: morningTasks.value.count, earlyCount: earlyAfternoonTasks.value.count, lateCount: lateAfternoonTasks.value.count)
    }
    
    // MARK: - ViewWillAppear Actions
    private func navigationItemSetup() {
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionThree)), UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock", withConfiguration: symbolConfiguration),  style: .plain, target: self, action: #selector(actionTwo)), UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionOne))]
    }
    
    /// Setting for Guide Box Appearance
    private func guideBoxSetup() {
        let guideBoxCheck = UserDefaults.standard.bool(forKey: SettingConfigurations.GuideBoxChecked.isChecked)
        switch guideBoxCheck {
        case true:
            return
        case false:
            view.addSubview(guideBox)
            guideBox.isHidden = false
            
            guideBox.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(40)
                $0.height.equalToSuperview().dividedBy(3.2)
            }
            
            guideBox.checkedGuideButton.rx.tap
                .withUnretained(self)
                .bind { _ in
                    UserDefaults.standard.set(true, forKey: SettingConfigurations.GuideBoxChecked.isChecked)
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.guideBox.alpha = 0
                    }, completion: { _ in self.guideBox.removeFromSuperview()})
                }
                .disposed(by: disposeBag)
        }
    }
    
    deinit {
        print("PlanView Out")
    }
}

    // MARK: - Other Supplementary Actions
extension PlanViewController {
    private func actions() {
        let AddMorningPlanTapped = UITapGestureRecognizer(target: self, action: #selector(moveToAddMorningPlan))
        let AddEarlyPlanTapped = UITapGestureRecognizer(target: self, action: #selector(moveToAddEarlyPlan))
        let AddLatePlanTapped = UITapGestureRecognizer(target: self, action: #selector(moveToAddLatePlan))
        
        morningSectionView.addTappedButton.addGestureRecognizer(AddMorningPlanTapped)
        earlyAfternoonSectionView.addTappedButton.addGestureRecognizer(AddEarlyPlanTapped)
        lateAfternoonSectionView.addTappedButton.addGestureRecognizer(AddLatePlanTapped)
    }
    
    // MARK: - Navigation Actions
    @objc
    private func actionOne() {
    }
    
    @objc
    private func actionTwo() {
    }
    
    @objc
    private func actionThree() {
    }
    
    @objc
    private func moveToAddMorningPlan() {
        let nextAddPlanView = AddPlanViewController()
        nextAddPlanView.changeCurrentDate(date: currentDate)
        nextAddPlanView.changeCurrentTimeZone(timeZone: .morningTime)
        nextAddPlanView.modalPresentationStyle = .fullScreen
        nextAddPlanView.delegate = self
        self.navigationController?.present(nextAddPlanView, animated: true)
    }
    
    @objc
    private func moveToAddEarlyPlan() {
        let nextAddPlanView = AddPlanViewController()
        nextAddPlanView.changeCurrentDate(date: currentDate)
        nextAddPlanView.changeCurrentTimeZone(timeZone: .earlyAfternoonTime)
        nextAddPlanView.modalPresentationStyle = .fullScreen
        nextAddPlanView.delegate = self
        self.navigationController?.present(nextAddPlanView, animated: true)
    }
    
    @objc
    private func moveToAddLatePlan() {
        let nextAddPlanView = AddPlanViewController()
        nextAddPlanView.changeCurrentDate(date: currentDate)
        nextAddPlanView.changeCurrentTimeZone(timeZone: .lateAfternoonTime)
        nextAddPlanView.modalPresentationStyle = .fullScreen
        nextAddPlanView.delegate = self
        self.navigationController?.present(nextAddPlanView, animated: true)
    }
}

    // MARK: - Extension for FSCalendar
extension PlanViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    /// Modifies Date and Datas as Date Changes
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDate = date
        plansViewModel.updateTableView(date: currentDate)
        updateTableHeight()
        updateSectionView()
    }
    
    internal func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}

    // MARK: - Extension for TableView Delegates
extension PlanViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// Swipe action settings
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlanItemTableViewCell else { return UISwipeActionsConfiguration() }
        let isExpired: Bool = cell.fetchIsExpired()
        let isCompleted: Bool = cell.fetchIsCompleted()
                
        if isExpired == true || isCompleted == true {
            cell.isUserInteractionEnabled = false
            
            return UISwipeActionsConfiguration()
        }

        let cellId = cell.fetchCellTaskId()
        
        let checkAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.plansViewModel.updatePlanCompleted(id: cellId)
            tableView.reloadRows(at: [indexPath], with: .right)
            completionHandler(true)
        }

        checkAction.backgroundColor = .Background
        checkAction.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))?.withTintColor(.PopGreen, renderingMode: .alwaysOriginal)
        let configuration = UISwipeActionsConfiguration(actions: [checkAction])

        return configuration
    }
}

extension PlanViewController: AddPlanDelegate {
    func reloadTableViews() {
        plansViewModel.updateTableView(date: currentDate)
        updateTableHeight()
        updateSectionView()
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
