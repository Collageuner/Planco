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
