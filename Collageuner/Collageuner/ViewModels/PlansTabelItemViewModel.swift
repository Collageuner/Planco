//
//  PlansTabelItemViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/19.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

final class PlansTableItemViewModel {
    let myPlanRealm = try! Realm()
    
    var disposeBag = DisposeBag()
    
    private var morningPlans: BehaviorRelay<[Tasks]> = BehaviorRelay(value: [])
    private var earlyAfternoonPlans: BehaviorRelay<[Tasks]> = BehaviorRelay(value: [])
    private var lateAfternoonPlans: BehaviorRelay<[Tasks]> = BehaviorRelay(value: [])
    
    private let morningPlanCounts: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let earlyAfternoonPlanCounts: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let lateAfternoonPlanCounts: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    func fetchPlansForTableView(timeZone: MyTimeZone, date: Date) -> BehaviorRelay<[Tasks]> {
        let dateKey = Date.dateToCheckDay(date: date)
        var taskFetchedArray: [Tasks] = []
        
        let realmResult = myPlanRealm.objects(Tasks.self).filter(NSPredicate(format: "keyForDayCheck = %@", dateKey)).filter("taskTimeZone = %@", timeZone.time)
        
        realmResult.forEach {
            taskFetchedArray.append($0)
        }
        
        taskFetchedArray.sort {
            $0.taskTime < $1.taskTime
        }
                
        switch timeZone {
        case .morningTime:
            _ = Observable.just(taskFetchedArray)
                .bind(to: morningPlans)
                .disposed(by: disposeBag)
            
            return morningPlans
        case .earlyAfternoonTime:
            _ = Observable.just(taskFetchedArray)
                .bind(to: earlyAfternoonPlans)
                .disposed(by: disposeBag)
            
            return earlyAfternoonPlans
        case .lateAfternoonTime:
            _ = Observable.just(taskFetchedArray)
                .bind(to: lateAfternoonPlans)
                .disposed(by: disposeBag)
            
            return lateAfternoonPlans
        }
    }
    
    func fetchCountOfPlans(timeZone: MyTimeZone) -> BehaviorRelay<Int> {
        let morningTaskNumber: Int = morningPlans.value.count
        let earlyAfternoonTaskNumber: Int = earlyAfternoonPlans.value.count
        let lateAfternoonTaskNumber: Int = lateAfternoonPlans.value.count
        
        switch timeZone {
        case .morningTime:
            _ = Observable.just(morningTaskNumber)
                .bind(to: morningPlanCounts)
                .disposed(by: disposeBag)
            
            return morningPlanCounts
        case .earlyAfternoonTime:
            _ = Observable.just(earlyAfternoonTaskNumber)
                .bind(to: earlyAfternoonPlanCounts)
                .disposed(by: disposeBag)
            
            return earlyAfternoonPlanCounts
        case .lateAfternoonTime:
            _ = Observable.just(lateAfternoonTaskNumber)
                .bind(to: lateAfternoonPlanCounts)
                .disposed(by: disposeBag)
            
            return lateAfternoonPlanCounts
        }
    }
    
    func updateTableView(date: Date) {
        let dateKey = Date.dateToCheckDay(date: date)
        
        for timeZone in MyTimeZone.allCases {
            var taskFetchedArray: [Tasks] = []

            let realmResult = myPlanRealm.objects(Tasks.self).filter(NSPredicate(format: "keyForDayCheck = %@", dateKey)).filter("taskTimeZone = %@", timeZone.time)
            
            realmResult.forEach {
                taskFetchedArray.append($0)
            }
            
            taskFetchedArray.sort {
                $0.taskTime < $1.taskTime
            }
            
            switch timeZone {
            case .morningTime:
                _ = Observable.just(taskFetchedArray)
                    .bind(to: morningPlans)
                    .disposed(by: disposeBag)
            case .earlyAfternoonTime:
                _ = Observable.just(taskFetchedArray)
                    .bind(to: earlyAfternoonPlans)
                    .disposed(by: disposeBag)
            case .lateAfternoonTime:
                _ = Observable.just(taskFetchedArray)
                    .bind(to: lateAfternoonPlans)
                    .disposed(by: disposeBag)
            }
        }
    }
    
    func updatePlanCounts(morningCount: Int, earlyCount: Int, lateCount: Int) {
        _ = Observable.just(morningCount)
            .bind(to: morningPlanCounts)
            .disposed(by: disposeBag)

        _ = Observable.just(earlyCount)
            .bind(to: earlyAfternoonPlanCounts)
            .disposed(by: disposeBag)

        _ = Observable.just(lateCount)
            .bind(to: lateAfternoonPlanCounts)
            .disposed(by: disposeBag)
    }
    
    func updatePlanCompleted(id: ObjectId) {
        guard let realmResult = myPlanRealm.object(ofType: Tasks.self, forPrimaryKey: id) else { return }
        
        do {
            try myPlanRealm.write({
                realmResult.taskCompleted = true
            })
        } catch let error {
            print(error)
        }
    }
}
