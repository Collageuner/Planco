//
//  TestttViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/30.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

class TestttViewController: UIViewController {

    let viewModel = MyTimeZoneViewModel()
    var disposeBag = DisposeBag()
    let labelddd = UILabel().then {
        $0.textColor = .red
    }
    
    lazy var buttonddd = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        self.navigationController?.popToRootViewController(animated: true)
    })).then {
        $0.setTitle("deinit?", for: .normal)
        $0.backgroundColor = .brown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(labelddd)
        view.addSubview(buttonddd)
        
        labelddd.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        buttonddd.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
        
        viewModel.lateAfternoonTimeZone
            .observe(on: MainScheduler.instance)
            .bind(to: labelddd.rx.text)
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("test deinit")
    }

}
