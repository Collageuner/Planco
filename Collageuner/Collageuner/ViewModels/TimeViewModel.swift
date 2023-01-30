//
//  TimeViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa

class TimeViewModel {
    // Date 활용해서 Time 모델에 대한 모든 로직 여기서!
    // 1. todayDate
    // 2. morningTime/earlyAfternoonTime/lateAfternoonTime 계산
    
    
    
    
    // return UserDefaults
//    var timeZoneString: String {
//        switch self {
//        case .morningTime:
//            return "🕖 07:00-12:00"
//        case .earlyAfternoonTime:
//            return "🕐 12:00-18:00"
//        case .lateAfternoonTime:
//            return "🕕 18:00-24:00"
//        }
//    }
    
    // enum -> 1주일 치 date 나타내기..? (미정)
    
    /// Collageuner/Collageuner/Models/
    
}

class MyTimeZoneViewModel {
    let mytimeRealm = try! Realm()
    lazy var timeZoneRealmResult = mytimeRealm.objects(MyTimeZoneString.self)
    
    let morningTimeZone: BehaviorRelay<String> = BehaviorRelay(value: "")
    let earlyAfternoonTimeZone: BehaviorRelay<String> = BehaviorRelay(value: "")
    let lateAfternoonTimeZone: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    /// query 도 따로 지정해서 만들자.
    init() { // 이렇게 하는거 아닌거 같은데... 여긴 필수적으로 리펙토링이 필요하겠다.
        
        /// 뭐할거냐면, 어차피 실제 서비스에서는 하나의 VC 에서 한번에 받을거고, DatePicker 로 옵셔널 분기처리도 할거니깐 count = 0 일때는 기본 값을 넣어주는 걸로만 하자.
//        if timeZoneRealmResult.count {
//
//        }
        
        // 일단은 실제 PublishSubject 가 잘 먹히는지 확인해야한다.
        let morningRealmResult = fetchMorningRealm()
        let earlyAfternoonRealmResult = fetchEarlyRealm()
        let lateAfternoonRealmResult = fetchLateRealm()

        print(morningRealmResult, earlyAfternoonRealmResult, lateAfternoonRealmResult)
        
        let mor: Observable<String> = Observable.just("\(morningRealmResult.hour):\(morningRealmResult.minute) ~ \(earlyAfternoonRealmResult.hour):\(earlyAfternoonRealmResult.minute)")
        _ = mor
            .bind(to: morningTimeZone)
        
        let rlPM: Observable<String> = Observable.just("\(earlyAfternoonRealmResult.hour):\(earlyAfternoonRealmResult.minute) ~ \(lateAfternoonRealmResult.hour):\(lateAfternoonRealmResult.minute)")
        _ = rlPM
            .bind(to: earlyAfternoonTimeZone)

        let ltPM: Observable<String> = Observable.just("\(lateAfternoonRealmResult.hour):\(lateAfternoonRealmResult.minute) ~ 12:00")
        _ = ltPM
            .bind(to: lateAfternoonTimeZone)
    }
    
    func saveTimeZone(zoneTime: Date, timeZone: MyTimeZone) {
        let timeZoneString = timeZone.rawValue
        let hour = hourToString(zoneDate: zoneTime)
        let minute = minuteToString(zoneDate: zoneTime)
        let isTimePM = isHourPM(zoneDate: zoneTime)
        
        var pmHour: String
        
        guard let hourCalculated = Int(hour) else { return }
        
        switch isTimePM {
        case true:
            pmHour = String(hourCalculated - 12)
        default:
            pmHour = String(hourCalculated)
        }
        
        switch timeZoneString {
        case "morningTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: pmHour, minute: minute, timeZone: "morningTime"))
            })
            print("morningTime Saved")
            print("Realm is located at:", mytimeRealm.configuration.fileURL!)
        case "earlyAfternoonTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: pmHour, minute: minute, timeZone: "earlyAfternoonTime"))
            })
            print("Realm is located at:", mytimeRealm.configuration.fileURL!)
            print("earlyAfternoonTime Saved")
        case "lateAfternoonTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: pmHour, minute: minute, timeZone: "lateAfternoonTime"))
            })
            print("lateAfternoonTime Saved")
        default:
            print("Error Saving MyTimeZone")
        }
    }
    
    func updateTimeZone(zoneTime: Date, timeZone: MyTimeZone) {
        let timeZoneString = timeZone.rawValue
        let hour = hourToString(zoneDate: zoneTime)
        let minute = minuteToString(zoneDate: zoneTime)
        let isTimePM = isHourPM(zoneDate: zoneTime)
        
        var pmHour: String
        
        guard let hourCalculated = Int(hour) else { return }
        
        switch isTimePM {
        case true:
            pmHour = String(hourCalculated - 12)
        default:
            pmHour = String(hourCalculated)
        }
        
        switch timeZoneString {
        case "morningTime":
            guard let morningUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "morningTime")).first else { return }
            try! mytimeRealm.write({
                morningUpdate.hour = pmHour
                morningUpdate.minute = minute
            })
            print("morningTime Updated")
        case "earlyAfternoonTime":
            guard let earlyAfternoonUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "earlyAfternoonTime")).first else { return }
            try! mytimeRealm.write({
                earlyAfternoonUpdate.hour = pmHour
                earlyAfternoonUpdate.minute = minute
            })
            print("earlyAfternoonTime Updated")
        case "lateAfternoonTime":
            guard let earlyAfternoonUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "lateAfternoonTime")).first else { return }
            try! mytimeRealm.write({
                earlyAfternoonUpdate.hour = pmHour
                earlyAfternoonUpdate.minute = minute
            })
            print("lateAfternoonTime Updated")
        default:
            print("Error Updating MyTimeZone")
        }
    }
    
    func refreshSubjects() {
        
    }
    
    private func fetchMorningRealm() -> MyTimeZoneString {
        guard let morningRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "morningTime")).first else {
            return MyTimeZoneString(hour: "7", minute: "00", timeZone: "morningTime")}
        return morningRealmResult
    }
    
    private func fetchEarlyRealm() -> MyTimeZoneString {
        guard let earlyAfternoonRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "earlyAfternoonTime")).first else {
            return MyTimeZoneString(hour: "12", minute: "00", timeZone: "earlyAfternoonTime")}
        return earlyAfternoonRealmResult
    }
    
    private func fetchLateRealm() -> MyTimeZoneString {
        guard let lateAfternoonRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "lateAfternoonTime")).first else {
            return MyTimeZoneString(hour: "6", minute: "00", timeZone: "lateAfternoonTime")}
        return lateAfternoonRealmResult
    }
    
    private func hourToString(zoneDate: Date) -> String {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hour = hourFormatter.string(from: zoneDate)
        
        return hour
    }
    
    private func minuteToString(zoneDate: Date) -> String {
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        let minute = minuteFormatter.string(from: zoneDate)
        
        return minute
    }
    
    private func isHourPM(zoneDate: Date) -> Bool {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hour = hourFormatter.string(from: zoneDate)
        
        guard let hourToInt = Int(hour) else {
            print("Modifying hour to Int Failed")
            return false
        }
        
        let checkHourPM = hourToInt > 12
        
        return checkHourPM
    }
}
