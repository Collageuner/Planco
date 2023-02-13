//
//  PlanViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

final class PlanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.PopGreen])
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "photo.stack", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionThree)), UIBarButtonItem(image: UIImage(systemName: "calendar", withConfiguration: symbolConfiguration),  style: .plain, target: self, action: #selector(actionTwo)), UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.clock", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(actionOne))]
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
