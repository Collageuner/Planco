//
//  AddImageToCanvasViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/27.
//

import UIKit

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class AddImageToCanvasViewController: UIViewController {
    private var selectedDate: Date!
    private var cellId: ObjectId!
    private var selectedImage: UIImage!
    private var selectedStickerView: StickerView?
    
    var disposeBag = DisposeBag()
    private let gardenCanvasViewModel = GardenCanvasViewModel(currentDate: Date())

    private let mainLabel = UILabel().then {
        $0.font = .customEnglishFont(.regular, forTextStyle: .title1)
        $0.textColor = .PopGreen
        $0.text = "My Canvas"
    }
    
    private let gardenCanvasBackgroundView = UIView().then {
        /// 여기에 canvas Model 에서 받아온 Color 를 바꿔서 넣으렴
        $0.backgroundColor = .clear
    }
    
    private let mainGardenCanvasView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        stickerViewSetup()
        layouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        
        let canvasImage = gardenCanvasViewModel.fetchCurrentDateCanvas(currentDate: selectedDate)
        mainGardenCanvasView.image = canvasImage
    }
    
    private func stickerViewSetup() {
        let imageWidth: CGFloat = selectedImage.size.width
        let widthScale: CGFloat = 100/imageWidth
        let imageHeightWithScale = selectedImage.size.height * widthScale
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: imageHeightWithScale))
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        let stickerView = StickerView.init(contentView: imageView)
        
        stickerView.delegate = self
        
        mainGardenCanvasView.addSubview(stickerView)
        stickerView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - imageHeightWithScale)
        
        self.selectedStickerView = stickerView
    }
    
    private func layouts() {
        view.addSubviews(mainLabel, gardenCanvasBackgroundView, mainGardenCanvasView)
        
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        mainGardenCanvasView.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(mainGardenCanvasView.snp.width).multipliedBy(1.414)
        }
        
        gardenCanvasBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(mainGardenCanvasView.snp.edges)
        }
    }

    private func navigationItemSetup() {
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(finishSaving))
        navigationItem.rightBarButtonItem?.tintColor = .PopGreen
    }
    
    @objc
    private func finishSaving() {
//        selectedStickerView?.hideExceptImage()
    }
    
    deinit {
        print("AddImageToCanvasView Out")
    }
}

extension AddImageToCanvasViewController {
    func saveCellId(id: ObjectId) {
        cellId = id
    }
    
    func saveSelectedDate(date: Date) {
        selectedDate = date
    }
    
    func passSelectedImage(image :UIImage?) {
        guard let imagePassed = image else {
            print("Passed Image went Wrong")
            return
        }
        
        selectedImage = imagePassed
    }
}

extension AddImageToCanvasViewController: StickerViewDelegate {
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
}
