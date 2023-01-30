//
//  RealmManager.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/29.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

extension Realm {
    
    // 일단 이렇게 해놓고 고도화 시켜보자 일단은! write 에 대해서도 정확한 func 을 만들고 해당 thread Safe 나 구동 safe 에 대한 공식적인 이야기가 확실해지면 그때 사용하도록 해보자. 실제 사용하면서 에러도 찾아야 하니깐!
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print(error)
            print("⚠️ Fetching Realm Failed")
            
            return nil
        }
    }
    
    // print("Realm is located at:", realm.configuration.fileURL!)
}

