//
//  CodesSaved.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/10.
//

import Foundation

    /// TimeViewModel
/*
 // Realm-NotificationToken
 var notificationTokent: NotificationToken?
 
 // viewWillAppear
 notifyToken()
 
 // viewWillDisappear
 notificationTokent?.invalidate()

 // bindings
 timeViewModel.morningTimeZone
     .observe(on: MainScheduler.instance)
     .bind(to: currentMonthLabel.rx.text)
     .disposed(by: disposeBag)
 
 timeViewModel.earlyAfternoonTimeZone
     .observe(on: MainScheduler.instance)
     .bind(to: currentDayLabel.rx.text)
     .disposed(by: disposeBag)
 
 // Function: Notify Rx Binding that Realm DB has changed.
 private func notifyToken() {
     let tokenRealm = timeViewModel.mytimeRealm.objects(MyTimeZoneString.self)

     notificationTokent = tokenRealm.observe { change in
         switch change {
         case .initial:
             print("Token Initialized")
         case .update(_, _, _, _):
             let newTimeViewModel = MyTimeZoneViewModel()
             newTimeViewModel.morningTimeZone
                 .observe(on: MainScheduler.instance)
                 .bind(to: self.currentMonthLabel.rx.text)
                 .disposed(by: self.disposeBag)
             newTimeViewModel.earlyAfternoonTimeZone
                 .observe(on: MainScheduler.instance)
                 .bind(to: self.currentDayLabel.rx.text)
                 .disposed(by: self.disposeBag)
             print("Modified Token")
         case .error(let error):
             print("Error in \(error)")
         }
     }
     
     print("Notifying Token Opened.")
 }
 */

    /// UICOllectionView + RxDataSource
/*
 struct TestStruct {
     let testLabel: String
 }

 struct PlanDataSection {
     var header: String
     var items: [TestStruct]
 }

 extension PlanDataSection: SectionModelType {
     typealias Item = TestStruct
     
     init(original: PlanDataSection, items: [TestStruct]) {
         self = original
         self.items = items
     }
 }
 ------
 VC: {
 
 
 private let sectionSubject = BehaviorRelay(value: [PlanDataSection]())
 
 private lazy var planCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout()).then {
     $0.isScrollEnabled = false
     $0.backgroundColor = .clear
     $0.register(PlanTimeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IdsForCollectionView.PlanSectionHeaderViewId.identifier)
     $0.register(PlanItemCollectionViewCell.self, forCellWithReuseIdentifier: IdsForCollectionView.PlanItemCollectionViewId.identifier)
 }
 
 private var dataSource: RxCollectionViewSectionedReloadDataSource<PlanDataSection>!
 
 let sections = [
     PlanDataSection(header: "오전", items: [TestStruct(testLabel: "오전Test!111"), TestStruct(testLabel: "오전 Test22")]),
     PlanDataSection(header: "오후", items: [TestStruct(testLabel: "오후333")]),
     PlanDataSection(header: "늦은 오후", items: [TestStruct(testLabel: "")])
 ]
        let sections = [PlanDataSection(header: "오전", items: [Tasks(taskTimeZone: "aaa", taskTime: "sdfsdf", keyForYearAndMonthCheck: "dgbdfb", keyForDayCheck: "asdasd", mainTask: "test!1", subTasks: ddd, taskExpiredCheck: false, taskCompleted: false), Tasks(taskTimeZone: "bb", taskTime: "bdb", keyForYearAndMonthCheck: "cvb", keyForDayCheck: "bbb", mainTask: "test!2222", subTasks: ddd, taskExpiredCheck: false, taskCompleted: false)])
        ]
 
 configureCollectionViewDataSource()
 
 sectionSubject.accept(sections)
 
 planCollectionView.snp.makeConstraints {
     $0.leading.trailing.equalToSuperview().inset(25)
     $0.top.equalTo(lineDivider.snp.bottom).offset(20)
     $0
 }
 
 sectionSubject
     .bind(to: planCollectionView.rx.items(dataSource: dataSource))
     .disposed(by: disposeBag)
 
 private func configureCollectionViewDataSource() {
     dataSource = RxCollectionViewSectionedReloadDataSource<PlanDataSection>(configureCell: { dataSource, planCollectionView, indexPath, item in
         let cell: PlanItemCollectionViewCell = planCollectionView.dequeueReusableCell(withReuseIdentifier: IdsForCollectionView.PlanItemCollectionViewId.identifier, for: indexPath) as! PlanItemCollectionViewCell
         cell.mainTaskLabel.text = item.testLabel
         return cell
     }, configureSupplementaryView: { (dataSource, planCollectionView, kind, indexPath) -> UICollectionReusableView in
         let header: PlanTimeSectionHeaderView = planCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IdsForCollectionView.PlanSectionHeaderViewId.identifier, for: indexPath) as! PlanTimeSectionHeaderView
         let sectionLabel = dataSource.sectionModels[indexPath.section].header
         header.planTimeZoneLabel.text = sectionLabel
         return header
     })
 }
 
 private func configureCollectionViewLayout() -> UICollectionViewLayout {
     let layout = UICollectionViewCompositionalLayout {
         _, _ in
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
         let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

         let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40.0))
         let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

         let section = NSCollectionLayoutSection(group: group)
         section.boundarySupplementaryItems = [header]

         return section
     }

     return layout
 }
 

 }
 */

    /// RxDataSource + Swipe Delete + Animation
/*
 
 self.planTableView.rx.itemDeleted
     .observe(on: MainScheduler.instance)
     .withUnretained(self)
     .bind {owner, indexPath in
         guard var section = try? owner.sections.value() else { return }
         var updateSection = section[indexPath.section]
         
         updateSection.items.remove(at: indexPath.item)
         
         section[indexPath.section] = updateSection
         
         owner.sections.onNext(section)
         
         // 여기에 이제 updateConstraints 를 switch 해서 timezone 별로 만들자.
         /// 아니지. 여기가 planTableView -> morningTableView 로 바뀌면 하나만 update 하면 되잖아 그치?
         if self.numberPlan > 0 {
             self.numberPlan -= 1
             UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                 self.planTableView.snp.updateConstraints {
                     $0.leading.trailing.equalToSuperview().inset(25)
                     $0.top.equalTo(self.lineDivider.snp.bottom).offset(20)
                     $0.height.equalTo(CGFloat(self.numberPlan) * self.view.frame.height/11.2)
                 }
                 self.view.layoutIfNeeded()
             }
         }
     }
     .disposed(by: disposeBag)
 
 ...
 
 func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
         tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: indexPath)
         
         completionHandler(true)
         print("----------------")
         print(try! self?.sections.value())
         print("----------------")
     }
     
     deleteAction.backgroundColor = .Background
     deleteAction.image = UIImage(systemName: "pencil.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.red, renderingMode: .alwaysOriginal)
     
     let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
     
     return configuration
 }
 
 */

/// 아 진짜 애니메이션 그거 하나때문에 난리를 쳤네용
/*
 
 
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
     
     var numberPlan = 4
     
     typealias PlanCellDataSource = RxTableViewSectionedAnimatedDataSource<MainPlanCellSection>
     
     var disposeBag = DisposeBag()
     private var dateToday: Date = Date()

     private lazy var morningDataSource: PlanCellDataSource = {
         let cellDataSource = PlanCellDataSource(configureCell: { dataSource, tableView, indexPath, plan -> UITableViewCell in
             guard let cell = tableView.dequeueReusableCell(withIdentifier: IdsForCollectionView.MorningPlanItemId.identifier, for: indexPath) as? PlanItemTableViewCell else { return UITableViewCell() }
             cell.updateUICell(cell: plan)
             
             return cell
         })
         
         cellDataSource.canEditRowAtIndexPath = { dataSource, indexPath in
             return true
         }
         
         cellDataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
             return false
         }
         
         return cellDataSource
     }()
     
 //    private var guideTapped: Bool = UserDefaults.standard.bool(forKey: "isGuideBoxTapped") {
 //        didSet {
 //            switch guideTapped {
 //            case false:
 //                guideBox.isHidden = false
 //            case true:
 //                guideBox.isHidden = true
 //            }
 //        }
 //    }
     
     private var guideTapped = BehaviorRelay(value: UserDefaults.standard.bool(forKey: "isGuideBoxTapped"))
     
     private lazy var taskViewModel = TasksViewModel(dateForList: dateToday)
     
     private lazy var weeklyCalendarView = FSCalendar(frame: .zero).then {
         $0.appearance.selectionColor = .MainCalendar
         $0.appearance.todayColor = .MainCalendar.withAlphaComponent(0.5)
         $0.appearance.titleWeekendColor = .SubText
         $0.appearance.weekdayTextColor = .SubGray.withAlphaComponent(0.8)
         $0.appearance.titleFont = .customVersatileFont(.medium, forTextStyle: .callout)
         $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 12, weight: .medium)
         $0.locale = Locale(identifier: "en_US")
         $0.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
         $0.weekdayHeight = CGFloat(25)
         $0.calendarHeaderView.isHidden = true
         $0.headerHeight = 0
         $0.scrollDirection = .horizontal
         $0.scrollEnabled = true
         $0.scope = .week
     }
     
     private let lineDivider = UIView().then {
         $0.backgroundColor = .MainGray
     }
     
     private let guideBox = PlanFirstGuideView(frame: .zero)
     
     private let morningPlanTableView = UITableView().then {
         $0.autoresizingMask = .flexibleHeight
         $0.allowsSelection = false
         $0.backgroundColor = .clear
         $0.separatorStyle = .none
         $0.isScrollEnabled = false
         $0.showsVerticalScrollIndicator = false
         $0.bounces = false
         $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.MorningPlanItemId.identifier)
     }
     
     private let earlyAfternoonPlanTableView = UITableView().then {
         $0.autoresizingMask = .flexibleHeight
         $0.allowsSelection = false
         $0.backgroundColor = .clear
         $0.separatorStyle = .none
         $0.isScrollEnabled = false
         $0.showsVerticalScrollIndicator = false
         $0.bounces = false
         $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.EarlyAfternoonPlanItemId.identifier)
     }
     
     private let lateAfternoonPlanTableView = UITableView().then {
         $0.autoresizingMask = .flexibleHeight
         $0.allowsSelection = false
         $0.backgroundColor = .clear
         $0.separatorStyle = .none
         $0.isScrollEnabled = false
         $0.showsVerticalScrollIndicator = false
         $0.bounces = false
         $0.register(PlanItemTableViewCell.self, forCellReuseIdentifier: IdsForCollectionView.LateAfternoonPlanItemId.identifier)
     }
     
     private var sections = BehaviorSubject(value: [
         MainPlanCellSection(header: "오전", items: [MainPlanCell(taskImage: "1111", mainTaskLabel: "오전 test111", subTasksLabel: [], taskTimeLabel: "11:00", isChecked: false, isExpired: false), MainPlanCell(taskImage: "1112", mainTaskLabel: "오전 test222", subTasksLabel: ["testSub 11"], taskTimeLabel: "12:00", isChecked: false, isExpired: false)
         ]), MainPlanCellSection(header: "이른 오후", items: [MainPlanCell(taskImage: "1113", mainTaskLabel: "이오 test111", subTasksLabel: ["testSub11", "testSub22"], taskTimeLabel: "5:00", isChecked: false, isExpired: false), MainPlanCell(taskImage: "1114", mainTaskLabel: "이오 test222", subTasksLabel: [], taskTimeLabel: "6:00", isChecked: false, isExpired: false)
                                                      ])
     ])
     
     private let backgroundPlantImage = UIImageView().then {
         $0.clipsToBounds = true
         $0.image = UIImage(named: "BackgroundPlantOne")
         $0.contentMode = .scaleAspectFit
     }
     
     private let testView = UIView().then {
         $0.backgroundColor = .red
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
         navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionThree)), UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock", withConfiguration: symbolConfiguration),  style: .plain, target: self, action: #selector(actionTwo)), UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionOne))]
     }
     
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         disposeBag = DisposeBag()
     }

     private func basicSetup() {
         view.backgroundColor = .Background
         weeklyCalendarView.delegate = self
         weeklyCalendarView.dataSource = self
         morningPlanTableView.rx.setDelegate(self).disposed(by: disposeBag)
     }
     
     private func layouts() {
         view.addSubviews(backgroundPlantImage, weeklyCalendarView, lineDivider, morningPlanTableView, testView)
         
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
         
         morningPlanTableView.snp.makeConstraints {
             $0.leading.trailing.equalToSuperview().inset(25)
             $0.top.equalTo(lineDivider.snp.bottom).offset(20)
             $0.height.equalTo(CGFloat(numberPlan) * view.frame.height/11.2)
         }
         
         testView.snp.makeConstraints {
             $0.top.equalTo(morningPlanTableView.snp.bottom).offset(20)
             $0.leading.trailing.equalToSuperview()
             $0.height.equalTo(10)
         }
     }
     
     private func bindings() {
         self.sections
             .distinctUntilChanged()
             .bind(to: morningPlanTableView.rx.items(dataSource: morningDataSource))
             .disposed(by: disposeBag)
         
 //        guideTapped
 //            .bind(to: guideBox.rx.isHidden)
 //            .disposed(by: disposeBag)
     }
     
     private func updateTableHeight(timeZone: MyTimeZone, date: Date) -> CGFloat {
         let rowNumber = taskViewModel.getNumberOfTasks(timeZone: timeZone, date: date)
         let tableViewSize = view.frame.height/11.2 * rowNumber
         return tableViewSize
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

 extension PlanViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return view.frame.height/11
     }
     
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let checkAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
             print("✅✅✅")
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

 
 
 */
