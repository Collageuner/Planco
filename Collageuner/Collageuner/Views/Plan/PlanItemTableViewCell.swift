//
//  PlanItemTableViewCell.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/14.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PlanItemTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private var cellTaskId: ObjectId = ObjectId()
    private var isPlanCompleted: Bool = false
    private var isPlanExpired: Bool = false
    
    private let backgroundCellView = UIView().then {
        $0.backgroundColor = UIColor(hex: "FDFDFD")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let pointUIView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .MainGreen
    }
   
    private let mainTaskLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .MainText.withAlphaComponent(0.9)
        $0.font = .customVersatileFont(.semibold, forTextStyle: .subheadline)
    }
    
    private let subTasksTopLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.regualar, forTextStyle: .footnote)
    }

    private let taskTimeLabel = UILabel().then {
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
    }
    
    private let taskImage = UIImageView().then {
        $0.backgroundColor = .Background
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskImage.clipsToBounds = true
        taskImage.layer.cornerRadius = self.taskImage.frame.height/2
        pointUIView.layer.cornerRadius = self.pointUIView.frame.height/2
    }
    
    private func render() {
        self.addSubviews(backgroundCellView, pointUIView, mainTaskLabel, taskTimeLabel, subTasksTopLabel, taskImage)
        
        backgroundCellView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom).inset(5)
        }
        
        pointUIView.snp.makeConstraints {
            $0.centerY.equalTo(backgroundCellView.snp.centerY)
            $0.leading.equalToSuperview().inset(15)
            $0.height.width.equalTo(8)
        }
        
        mainTaskLabel.snp.makeConstraints {
            $0.leading.equalTo(pointUIView.snp.trailing).offset(12)
            $0.centerY.equalTo(backgroundCellView.snp.centerY).offset(-10)
            $0.width.equalToSuperview().dividedBy(1.67)
        }
        
        taskTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(mainTaskLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        subTasksTopLabel.snp.makeConstraints {
            $0.leading.equalTo(pointUIView.snp.trailing).offset(12)
            $0.centerY.equalTo(backgroundCellView.snp.centerY).offset(10)
            $0.width.equalToSuperview().dividedBy(1.67)
        }
    }
    
    func updateUICell(cell: Tasks) {
        let timeStamp = cell.taskTime.changeHourIntoShort
        
        mainTaskLabel.text = cell.mainTask
        taskTimeLabel.text = timeStamp
        cellTaskId = cell._id
        isPlanCompleted = cell.taskCompleted
        isPlanExpired = cell.taskExpiredCheck
        
        if isPlanExpired == true {
            backgroundCellView.backgroundColor = UIColor(hex: "#CBCBCB")
            self.subviews.forEach {
                $0.layer.opacity = 0.9
            }
        } else {
            if isPlanCompleted == true {
                backgroundCellView.backgroundColor = UIColor(hex: "#EAEAEA")
                let imageFetched = loadThumbnailImageFromDirectory(imageName: "\(cell.taskTime)\(cell._id.stringValue)")
                taskImage.image = imageFetched
                taskImage.isHidden = false
                        
                taskImage.snp.makeConstraints {
                    $0.centerY.equalTo(backgroundCellView.snp.centerY)
                    $0.height.width.equalTo(self.frame.height/1.7)
                    $0.trailing.equalTo(taskTimeLabel.snp.leading).offset(-10)
                }
            } else {
                taskImage.isHidden = true
                backgroundCellView.backgroundColor = UIColor(hex: "FDFDFD")
            }
        }
        
        switch cell.emotion.isNilorEmpty {
        case true:
            subTasksTopLabel.text = "-"
            subTasksTopLabel.textColor = .SubText.withAlphaComponent(0.7)
        case false:
            guard let emotion = cell.emotion else { return }
            subTasksTopLabel.text = emotion
        }
    }
    
    func fetchCellTaskId() -> ObjectId {
        return cellTaskId
    }
    
    func fetchIsCompleted() -> Bool {
        return isPlanCompleted
    }
    
    func fetchIsExpired() -> Bool {
        return isPlanExpired
    }
    
    private func loadThumbnailImageFromDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let thumbnailDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.TaskThumbnailImages.dataDirectory) else {
            print("Failed fetching directory for Thumbnail Images for Task List")
            return UIImage(named: "TaskDefaultImage")
        }
        let imageURL = thumbnailDirectoryURL.appending(component: "Thumbnail_\(imageName).png")
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Succeeded fetching Thumbnail Images")
            return UIImage(data: imageData)
        } catch let error {
            print("Failed fetching Thumbnail Images for Task List")
            print(error)
        }
        
        print("Returning Default Image.")
        return UIImage(named: "TaskDefaultImage")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
