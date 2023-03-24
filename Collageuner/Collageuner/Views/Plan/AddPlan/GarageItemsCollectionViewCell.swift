//
//  GarageSheetCollectionViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/27.
//

import UIKit

import RealmSwift
import SnapKit
import Then

final class GarageItemsCollectionViewCell: UICollectionViewCell {
    private var cellId: ObjectId?
    
    let garageImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        garageImageView.clipsToBounds = true
        garageImageView.layer.cornerRadius = 15
    }
    
    private func render() {
        self.addSubview(garageImageView)
        
        garageImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func putIdToCell(id: ObjectId) {
        cellId = id
    }
    
    func fetchCellId() -> ObjectId {
        guard let id = cellId else { return ObjectId() }
        return id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
