//
//  StickerView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/30.
//

import UIKit

import SnapKit
import Then

final class StickerView: UIView {
    var delegate: StickerViewDelegate?
    var contentView: UIView!
    
    private var minimumSizeZero: Int = 0
    private var minimumSize: Int {
        set {
            minimumSizeZero = max(newValue, self.defaultMinimumSize)
        }
        get {
            return minimumSizeZero
        }
    }
    
    private var defaultInset: Int
    private var defaultMinimumSize: Int
    
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    private var initialBounds = CGRect.zero
    private var initialDistance: CGFloat = 0.0
    private var rotatedAngle: CGFloat = 0.0
    
    private let gripImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light))
        $0.tintColor = .MainGray
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    init(contentView: UIView) {
        self.defaultInset = 10
        self.defaultMinimumSize = 4 * self.defaultInset
        
        var frame = contentView.frame
        frame = CGRect(x: 0, y: 0, width: frame.size.width + CGFloat(self.defaultInset) * 2, height: frame.size.height + CGFloat(self.defaultInset) * 2)
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        basicGestureSetup()
        
        self.contentView = contentView
        self.contentView.center = rectGetCenter(rect: self.bounds)
        self.contentView.isUserInteractionEnabled = false // 왜 false?
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.layer.allowsEdgeAntialiasing = true
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.addSubview(self.contentView)
        
        self.minimumSize = self.defaultMinimumSize
        
        handleLayout()
    }
    
    private func basicGestureSetup() {
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
        let rotateGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        self.addGestureRecognizer(moveGesture)
        self.addGestureRecognizer(tapGesture)
        gripImageView.addGestureRecognizer(rotateGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StickerView {
    @objc
    private func handleMoveGesture(_ recognizer :UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        switch recognizer.state {
        case .began:
            self.beginningPoint = touchLocation
            self.beginningCenter = self.center
            self.delegate?.stickerViewDidBeginMoving(self)
        case .changed:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            self.delegate?.stickerViewDidChangeMoving(self)
        case .ended:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            self.delegate?.stickerViewDidEndMoving(self)
        default: break
        }
    }
    
    @objc
    private func handleRotateGesture(_ recognizer :UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        let center = self.center
        
        switch recognizer.state {
        case .began:
            print("handle Touched")
            self.rotatedAngle = CGFloat(atan2(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - rectGetAngle(self.transform)
            self.initialBounds = self.bounds
            self.initialDistance = rectGetDistance(pointA: center, pointB: touchLocation)
            self.delegate?.stickerViewDidBeginRotating(self)
        case .changed:
            let angle = atan2(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDifference = Float(self.rotatedAngle) - angle
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDifference))
            
            var scale = rectGetDistance(pointA: center, pointB: touchLocation) / self.initialDistance
            let minimumScale = CGFloat(self.minimumSize) / min(self.initialBounds.size.width, self.initialBounds.height)
            scale = max(scale, minimumScale)
            let scaledBounds = rectGetScale(rect: self.initialBounds, widthScale: scale, heightScale: scale)
            
            self.bounds = scaledBounds
            self.setNeedsDisplay()
            
            self.delegate?.stickerViewDidChangeRotating(self)
        case .ended:
            self.delegate?.stickerViewDidEndRotating(self)
        default: break
        }
    }
    
    @objc
    private func handleTapGesture(_ :UIPanGestureRecognizer) {
        self.delegate?.stickerViewDidTap(self)
    }
    
    private func handleLayout() {
        self.addSubview(gripImageView)
        
        gripImageView.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.trailing)
            $0.centerY.equalTo(contentView.snp.top)
        }
    }
    
    func hideExceptImage() {
        self.gripImageView.isHidden = true
        self.gripImageView.isUserInteractionEnabled = false
        self.gripImageView.removeFromSuperview()
    }
}

extension StickerView {
    /// return the Center of given CGRect
    private func rectGetCenter(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    /// return the Scaled Rect from given scales
    private func rectGetScale(rect: CGRect, widthScale: CGFloat, heightScale: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * widthScale, height: rect.size.height * heightScale)
    }
    
    /// return the Angle from given CGAffineTransform
    private func rectGetAngle(_ form: CGAffineTransform) -> CGFloat {
        // a: the entry at position [1,1] in the Matrix
        // b: the entry at position [1,2] in the Matrix
        return atan2(form.b, form.a)
    }
    
    /// return the Distance from a point to other point
    private func rectGetDistance(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        let dxSquare: CGFloat = pow((pointA.x - pointB.x), 2.0)
        let dySquare: CGFloat = pow((pointA.y - pointB.y), 2.0)
        return sqrt(dxSquare + dySquare)
    }
}

extension StickerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
