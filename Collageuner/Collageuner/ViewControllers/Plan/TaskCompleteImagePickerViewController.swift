//
//  TaskCompleteImagePickerViewController.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/25.
//

import UIKit
import Photos

import Lottie
import RealmSwift
import RxSwift
import RxCocoa
import SnapKit
import Then

final class TaskCompleteImagePickerViewController: UIViewController {

    private var cellId: ObjectId!
    
    private var originalScale: CGAffineTransform!
    private lazy var halfDistanceBetweenButtons: CGFloat = view.frame.width/5.3
    
    weak var delegate: AddPlanDelegate?
    
    var disposeBag = DisposeBag()
    private let planTaskViewModel = PlansTableItemViewModel()
    private let taskImageSubject: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    private let mainLabel = UILabel().then {
        $0.font = .customEnglishFont(.regular, forTextStyle: .title1)
        $0.textColor = .PopGreen
        $0.text = "The Memory"
    }
    
    private let suggestingLabel = UILabel().then {
        $0.font = .customVersatileFont(.medium, forTextStyle: .subheadline)
        $0.textColor = .SubGray.withAlphaComponent(0.8)
        $0.text = "당신은 기록을 할 수 있고, 그저 넘길 수 있어요."
    }
    
    private let emotionLabel = UILabel().then {
        $0.textColor = .LateAfternoonColor
        $0.text = "정성스럽게, 그리고 조심스럽게 기록해주세요.\n왜냐하면 당신이 끝낸 일과 그에 대한 감정은\n소중하고, 사라지지 않았으면 좋겠으니까요."
        $0.numberOfLines = 3
        $0.font = .customVersatileFont(.semibold, forTextStyle: .callout)
    }
    
    private let selectedImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    private let defaultLottieView = LottieAnimationView.init(name: "EmptyPlanTaskImage").then {
        $0.backgroundColor = .clear
        $0.loopMode = .loop
        $0.animationSpeed = 1.7
        $0.contentMode = .scaleAspectFit
        $0.play()
    }
    
    private lazy var fetchImageFromAlbumButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        self?.presentAlbumGalleryViewToAdd()
    })).then {
        $0.clipsToBounds = true
        $0.setImage(UIImage(named: "ApplePhotoAlbumLogo"), for: .normal)
    }
    
    private lazy var fetchImageFromGarageButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
        self?.presentGarageSheetViewToAdd()
    })).then {
        $0.setImage(UIImage(named: "GarageAppIcon"), for: .normal)
    }
    
    private let albumButtonLabel = UILabel().then {
        $0.textColor = .MainText
        $0.text = "From My Album"
        $0.font = .customVersatileFont(.semibold, forTextStyle: .footnote)
    }
    
    private let garageButtonLabel = UILabel().then {
        $0.textColor = .MainText
        $0.text = "From My Garage"
        $0.font = .customVersatileFont(.semibold, forTextStyle: .footnote)
    }
    
    private let stackViewForAlbum = UIStackView().then {
        $0.spacing = 5
        $0.distribution = .fillProportionally
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.axis = .vertical
    }
    
    private let stackViewForGarage = UIStackView().then {
        $0.spacing = 5
        $0.distribution = .fillProportionally
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.axis = .vertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        layouts()
        bindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemSetup()
    }
    
    private func basicSetup() {
        view.backgroundColor = .Background
        addingPinchGesture()
    }
    
    private func layouts() {
        stackViewForAlbum.addArrangedSubview(fetchImageFromAlbumButton)
        stackViewForAlbum.addArrangedSubview(albumButtonLabel)
        
        stackViewForGarage.addArrangedSubview(fetchImageFromGarageButton)
        stackViewForGarage.addArrangedSubview(garageButtonLabel)
        
        view.addSubviews(mainLabel, suggestingLabel, emotionLabel, defaultLottieView, stackViewForAlbum, stackViewForGarage, selectedImageView)
        
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        suggestingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(mainLabel.snp.bottom).offset(5)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(suggestingLabel.snp.bottom).offset(5)
        }
        
        selectedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30)
            $0.width.equalToSuperview().dividedBy(1.6)
            $0.height.equalToSuperview().dividedBy(2.5)
        }
        
        defaultLottieView.snp.makeConstraints {
            $0.center.equalTo(selectedImageView.snp.center)
            $0.height.width.equalTo(240)
        }
        
        stackViewForAlbum.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-halfDistanceBetweenButtons)
            $0.bottom.equalToSuperview().inset(80)
            $0.height.equalTo(90)
        }
        
        stackViewForGarage.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(halfDistanceBetweenButtons)
            $0.bottom.equalTo(stackViewForAlbum.snp.bottom)
            $0.height.equalTo(90)
        }
        
        fetchImageFromAlbumButton.snp.makeConstraints {
            $0.height.width.equalTo(view.snp.width).dividedBy(7)
        }
        
        fetchImageFromGarageButton.snp.makeConstraints {
            $0.height.width.equalTo(view.snp.width).dividedBy(7)
        }
    }
    
    private func bindings() {
        taskImageSubject.asDriver()
            .drive(selectedImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func addingPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom(_:)))
        selectedImageView.addGestureRecognizer(pinchGesture)
        selectedImageView.isUserInteractionEnabled = true
        
        originalScale = selectedImageView.transform
    }
    
    private func presentAlbumGalleryViewToAdd() {
        DispatchQueue.main.async {
            let galleryVC = GalleryViewForCompleteTaskViewController()
            galleryVC.modalPresentationStyle = .overFullScreen
            galleryVC.customNavigationView.setTitleForDoneButtonWith(title: "Next", titleColor: .PopGreen)
            galleryVC.delegate = self
            self.present(galleryVC, animated: true)
        }
    }
    
    private func presentGarageSheetViewToAdd() {
        let garageBottomSheetVC = GarageImageSheetViewController()
        garageBottomSheetVC.delegate = self
        garageBottomSheetVC.modalPresentationStyle = .pageSheet
        
        if let sheet = garageBottomSheetVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.9
                }
            ]
        }
        
        self.present(garageBottomSheetVC, animated: true)
    }
    
    private func navigationItemSetup() {
        navigationController?.navigationBar.tintColor = .MainGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(moveNext))
    }
    
    private func alertWhenNoImageIsSelected() {
        let alertController = UIAlertController(title: "사진이 선택되지 않았어요.", message: "사진 없이 기록을 끝내시나요?", preferredStyle: .alert)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(hex: "#465E62")
        alertController.view.tintColor = .PopGreen
        
        let okAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.saveTaskDoneWithoutImage()
            self?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func saveTaskDoneWithoutImage() {
        planTaskViewModel.updatePlanCompleted(id: cellId)
        self.delegate?.reloadTableViews()
    }
    
    @objc
    private func pinchToZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else {return}
        
        view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        gestureRecognizer.scale = 1.0
        
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3) {
                view.transform = self.originalScale
            }
        }
    }
    
    @objc
    private func moveNext() {
        if taskImageSubject.value == nil {
            alertWhenNoImageIsSelected()
        } else {
            let tempVC = ProfileSettingViewController()
            self.navigationController?.pushViewController(tempVC, animated: true)
            // let newVC = UIViewController()
            // 1. relay.value 넘기는 함수 받기
            // 2. cellId 도 똑같이 넘기기
            // 3. 네비로 넘기기
            // 그러면... 다시 돌아와도... 그 뭐냐 저거 남아있으려나 value..?
        }
    }
    
    deinit {
        print("TaskCompleteImagePickerViewController Out")
    }
}

extension TaskCompleteImagePickerViewController {
    func saveCellId(id: ObjectId) {
        cellId = id
    }
}

extension TaskCompleteImagePickerViewController: GarageViewDelegate {
    func fetchImage(selectedImageData: Data) {
        guard let pngImage = UIImage(data: selectedImageData) else { return }
        
        _ = Observable.just(pngImage)
            .bind(to: taskImageSubject)
            .disposed(by: disposeBag)
        
        defaultLottieView.isHidden = true
    }
}

extension TaskCompleteImagePickerViewController: GarageSheetDelegate {
    func fetchImageFromGarageSheet(garageImage: UIImage) {
        
        _ = Observable.just(garageImage)
            .bind(to: taskImageSubject)
            .disposed(by: disposeBag)
        
        defaultLottieView.isHidden = true
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
