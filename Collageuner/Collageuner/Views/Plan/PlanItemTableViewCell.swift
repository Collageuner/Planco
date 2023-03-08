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
    
    let backgroundCellView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    let taskImage = UIImageView().then {
        $0.backgroundColor = .Background
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    let mainTaskLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .MainText.withAlphaComponent(0.9)
        $0.font = .customVersatileFont(.bold, forTextStyle: .subheadline)
    }
    
    let subTasksTopLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
    }
    
    let subTasksBottomLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
    }
    
    let taskTimeLabel = UILabel().then {
        $0.textColor = .SubText
        $0.font = .customVersatileFont(.medium, forTextStyle: .footnote)
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
    }
    
    private func render() {
        self.addSubviews(backgroundCellView, taskImage, mainTaskLabel, taskTimeLabel, subTasksTopLabel, subTasksBottomLabel)
        
        backgroundCellView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom).inset(5)
        }
        
        taskImage.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(10)
            $0.bottom.equalTo(backgroundCellView.snp.bottom).inset(10)
            $0.centerY.equalTo(backgroundCellView.snp.centerY)
            $0.width.equalTo(taskImage.snp.height).multipliedBy(1.0/1.0)
        }
        
        mainTaskLabel.snp.makeConstraints {
            $0.leading.equalTo(taskImage.snp.trailing).offset(23)
            $0.top.equalToSuperview().inset(9)
            $0.width.equalToSuperview().dividedBy(1.8)
        }
        
        taskTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(mainTaskLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        subTasksTopLabel.snp.makeConstraints {
            $0.leading.equalTo(taskImage.snp.trailing).offset(18)
            $0.top.equalTo(mainTaskLabel.snp.bottom).offset(3)
            $0.width.equalToSuperview().dividedBy(1.48)
        }
        
        subTasksBottomLabel.snp.makeConstraints {
            $0.leading.equalTo(taskImage.snp.trailing).offset(18)
            $0.top.equalTo(subTasksTopLabel.snp.bottom).offset(1.5)
            $0.width.equalToSuperview().dividedBy(1.48)
        }
    }
    
    func updateUICell(cell: Tasks) {
        let imageFetched = loadThumbnailImageFromDirectory(imageName: "\(cell.taskTime)\(cell._id.stringValue)")
        var timeStamp = String(cell.taskTime.suffix(4))
        timeStamp.insert(":", at: timeStamp.index(timeStamp.startIndex, offsetBy: 2))
        taskImage.image = imageFetched
        mainTaskLabel.text = cell.mainTask
        taskTimeLabel.text = timeStamp
        cellTaskId = cell._id
        isPlanCompleted = cell.taskCompleted
        isPlanExpired = cell.taskExpiredCheck
        
        let subTasksUnwrapped = cell.subTasks.compactMap { $0 }
        
        if isPlanExpired == true {
            backgroundCellView.backgroundColor = .MainGray.withAlphaComponent(0.9)
            self.subviews.forEach {
                $0.layer.opacity = 0.8
            }
        } else {
            if isPlanCompleted == true {
                self.subviews.forEach {
                    $0.layer.opacity = 0.8
                }
            }
        }
        
        switch cell.subTasks.count {
        case 0:
            subTasksTopLabel.text = "🪴 \(cell.mainTask)"
        case 1:
            subTasksTopLabel.text = "🪴 \(subTasksUnwrapped[0])"
        case 2:
            subTasksTopLabel.text = "🪴 \(subTasksUnwrapped[0])"
            subTasksBottomLabel.text = "🪴 \(subTasksUnwrapped[1])"
        default:
            print("Error in PlanItemCell")
            return
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
