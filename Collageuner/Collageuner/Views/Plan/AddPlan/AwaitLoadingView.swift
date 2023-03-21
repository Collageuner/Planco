//
//  AwaitLoadingView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/27.
//

import UIKit

import Lottie

final class AwaitLoadingView: UIView {
    private var loadingImage = LottieAnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstraints()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubview(loadingImage)
        
        loadingImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(300)
        }
    }
    
    func selectLottieFileName(lottieName : String) {
        loadingImage = .init(name: lottieName)
        loadingImage.loopMode = .loop
        loadingImage.animationSpeed = 1.3
        loadingImage.contentMode = .scaleAspectFit
        loadingImage.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
