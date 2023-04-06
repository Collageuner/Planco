//
//  ProfileSettingViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/12.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ProfileSettingViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    private let updatedRedDot = UIImageView(image: UIImage(named: "UpdateNotifyingDot")).then {
        $0.isHidden = true
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var profileImageWidth: CGFloat = view.frame.width / 4.4
    
    private let profileViewModel = ProfileSettingViewModel()
    private lazy var menuArray = profileViewModel.fetchMenus()
    private lazy var symbolArray = profileViewModel.fetchSymbols()
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "defaultProfileImage")
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }
    
    private let profileUserName = UILabel().then {
        $0.text = "피칸파이"
        $0.textAlignment = .center
        $0.font = .customVersatileFont(.light, forTextStyle: .title3)
    }
    
    private let editButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
        print("edit profile")
    })).then {
        $0.layer.cornerRadius = 15
        $0.setTitle("Edit Profile", for: .normal)
        $0.titleLabel?.font = .customVersatileFont(.light, forTextStyle: .subheadline)
        $0.titleLabel?.tintColor = .white
        $0.backgroundColor = .MainGray
    }
    
    private let profileTableView = UITableView().then {
        $0.register(ProfileSettingTableViewCell.self, forCellReuseIdentifier: IdsForTableView.ProfleTableView.identifier)
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.separatorColor = .systemGray5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    private func layouts() {
        view.addSubviews(profileImageView, profileUserName, editButton, profileTableView)
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.width.height.equalTo(profileImageWidth)
        }
        
        profileUserName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
        }
        
        editButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileUserName.snp.bottom).offset(18)
            $0.width.equalTo(profileImageWidth)
            $0.height.equalTo(40)
        }
        
        profileTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(editButton.snp.bottom).offset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func navigationItemSetup() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "questionmark.circle.fill", withConfiguration: symbolConfiguration), style: .plain, target: self, action: #selector(openUserManual))
        ]
        navigationItem.rightBarButtonItem?.tintColor = .MainCalendar
    }

    @objc
    private func openUserManual() {
        print("hello I'm your assistance Sir.")
    }
    
    deinit {
        print("ProfileView Out")
    }
}

extension ProfileSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IdsForTableView.ProfleTableView.identifier, for: indexPath) as? ProfileSettingTableViewCell else { return UITableViewCell() }
        
        cell.setCellUI(menu: menuArray[indexPath.row], symbol: symbolArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = view.frame.height / 15
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileSettingTableViewCell else { return }
        print(menuArray[indexPath.row])
    }
}
