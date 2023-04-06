//
//  ProfileViewModel.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

import SnapKit
import Then

final class ProfileSettingViewModel {
    private let profileMenus: [String] = ["알림 설정", "다크 모드 설정", "공지사항 / 이벤트", "피드백 / 오류 신고", "데이터 백업", "데이터 삭제", "결제 내역", "앱 정보"]
    
    private let profileSymbolNames: [String] = ["bell.badge.fill", "iphone.rear.camera", "star.bubble.fill", "exclamationmark.bubble.fill", "icloud.and.arrow.up.fill", "xmark.bin.fill", "creditcard.circle.fill", "questionmark.app.dashed"]
    
    func fetchMenus() -> [String] {
        return profileMenus
    }
    
    func fetchSymbols() -> [String] {
        return profileSymbolNames
    }
}
