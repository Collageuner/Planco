//
//  TaskCompleteImagePickerViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/25.
//

import UIKit

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class TaskCompleteImagePickerViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }

    private func navigationItemSetup() {
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.title = "기록하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(moveNext))
    }
    
    @objc
    private func moveNext() {
        
    }
    
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct PlanViewController_PreViews: PreviewProvider {
//    static var previews: some View {
//        TaskCompleteImagePickerViewController().toPreview()
//    }
//}
//#endif
