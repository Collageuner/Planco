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

final class MyTimeZoneViewModel {
    let mytimeRealm = try! Realm()
    
    var disposeBag = DisposeBag()
    
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
        let morningRealmResult = fetchMorningDateComponents()
        let earlyAfternoonRealmResult = fetchEarlyDateComponents()
        let lateAfternoonRealmResult = fetchLateDateComponents()
        
        let morningString: String = "\(morningRealmResult.hour):\(morningRealmResult.minute) \(morningRealmResult.noon)"
        let earlyAfternoonString: String = "\(earlyAfternoonRealmResult.hour):\(earlyAfternoonRealmResult.minute) \(earlyAfternoonRealmResult.noon)"
        let lateAfternoonString: String = "\(lateAfternoonRealmResult.hour):\(lateAfternoonRealmResult.minute) \(lateAfternoonRealmResult.noon)"
        
        // morningRealmObservable
        _ = Observable.just("\(morningString) - \(earlyAfternoonString)")
            .bind(to: morningTimeZone)
            .disposed(by: disposeBag)
        
        // earlyAfternoonRealmObservable
        _ = Observable.just("\(earlyAfternoonString) - \(lateAfternoonString)")
            .bind(to: earlyAfternoonTimeZone)
            .disposed(by: disposeBag)
        
        // lateAfternoonRealmObservabke
        _ = Observable.just("\(lateAfternoonString) - 12:00 am")
            .bind(to: lateAfternoonTimeZone)
            .disposed(by: disposeBag)
    }
    
    func saveTimeZone(zoneTime: Date, timeZone: MyTimeZone) {
        let timeZoneString = timeZone.time
        guard let isTimePM = isHourPM(zoneDate: zoneTime) else { return }
        let hour = isTimePM.hour
        let minute = isTimePM.minute
        let noon = isTimePM.noon
        
        switch timeZoneString {
        case "morningTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: hour, minute: minute, timeZone: "morningTime", noon: noon))
            })
            print("morningTime Saved")
        case "earlyAfternoonTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: hour, minute: minute, timeZone: "earlyAfternoonTime", noon: noon))
            })
            print("earlyAfternoonTime Saved")
        case "lateAfternoonTime":
            try! mytimeRealm.write({
                mytimeRealm.add(MyTimeZoneString(hour: hour, minute: minute, timeZone: "lateAfternoonTime", noon: noon))
            })
            print("lateAfternoonTime Saved")
        default:
            print("Error Saving MyTimeZone")
        }
    }
    
    func updateTimeZone(zoneTime: Date, timeZone: MyTimeZone) {
        let timeZoneString = timeZone.time
        guard let isTimePM = isHourPM(zoneDate: zoneTime) else { return }
        let hour = isTimePM.hour
        let minute = isTimePM.minute
        let noon = isTimePM.noon
        
        switch timeZoneString {
        case "morningTime":
            guard let morningUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "morningTime")).first else { return }
            try! mytimeRealm.write({
                morningUpdate.hour = hour
                morningUpdate.minute = minute
                morningUpdate.noon = noon
            })
            print("morningTime Updated")
        case "earlyAfternoonTime":
            guard let earlyAfternoonUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "earlyAfternoonTime")).first else { return }
            try! mytimeRealm.write({
                earlyAfternoonUpdate.hour = hour
                earlyAfternoonUpdate.minute = minute
                earlyAfternoonUpdate.noon = noon
            })
            print("earlyAfternoonTime Updated")
        case "lateAfternoonTime":
            guard let lateAfternoonUpdate = mytimeRealm.objects(MyTimeZoneString.self).filter(NSPredicate(format: "timeZone = %@", "lateAfternoonTime")).first else { return }
            try! mytimeRealm.write({
                lateAfternoonUpdate.hour = hour
                lateAfternoonUpdate.minute = minute
                lateAfternoonUpdate.noon = noon
            })
            print("lateAfternoonTime Updated")
        default:
            print("Error Updating MyTimeZone")
        }
    }
    
    func fetchMorningDateComponents() -> MyTimeZoneString {
        guard let morningRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "morningTime")).first else {
            return MyTimeZoneString(hour: "7", minute: "00", timeZone: "morningTime", noon: "am")}
        return morningRealmResult
    }
    
    func fetchEarlyDateComponents() -> MyTimeZoneString {
        guard let earlyAfternoonRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "earlyAfternoonTime")).first else {
            return MyTimeZoneString(hour: "12", minute: "00", timeZone: "earlyAfternoonTime", noon: "pm")}
        return earlyAfternoonRealmResult
    }
    
    func fetchLateDateComponents() -> MyTimeZoneString {
        guard let lateAfternoonRealmResult = timeZoneRealmResult.filter(NSPredicate(format: "timeZone = %@", "lateAfternoonTime")).first else {
            return MyTimeZoneString(hour: "6", minute: "00", timeZone: "lateAfternoonTime", noon: "pm")}
        return lateAfternoonRealmResult
    }

    private func isHourPM(zoneDate: Date) -> HourMinuteString? {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        let hour = String(hourFormatter.string(from: zoneDate).prefix(2))
        let minute = String(hourFormatter.string(from: zoneDate).suffix(2))
        
        guard let hourToInt = Int(hour) else {
            print("Failed To Convert Date to HourMinuteString.")
            return nil }
        
        switch hourToInt {
        case 0...11:
            return HourMinuteString(hour: hour, minute: minute, noon: "am")
        case 12...23:
            return HourMinuteString(hour: String(hourToInt - 12), minute: minute, noon: "pm")
        default:
            print("Failed To Convert Date to HourMinuteString.")
            return nil
        }
    }
}
