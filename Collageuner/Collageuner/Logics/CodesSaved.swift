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
