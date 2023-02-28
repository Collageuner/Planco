//
//  AwaitLoadingView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/27.
//

import UIKit

import Lottie

final class AwaitLoadingView: UIView {
    
    private let loadingImage: LottieAnimationView = .init(name: "loadingView").then {
        $0.loopMode = .loop
        $0.animationSpeed = 1.3
        $0.contentMode = .scaleAspectFit
        $0.play(toFrame: 300)
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
