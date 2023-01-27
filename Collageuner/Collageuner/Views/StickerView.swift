//
//  StickerView.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/27.
//

import UIKit

class StickerView: UIView {
    var panGestureRecognizer: UIPanGestureRecognizer!
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var rotationGestureRecognizer: UIRotationGestureRecognizer!
    private var transformedX: CGFloat = 1
    private var transformedY: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))

        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(rotationGestureRecognizer)
    }

    func flipHorizontal() {
        self.transform = CGAffineTransform(scaleX: transformedX * -1, y: transformedY)
    }

    func flipVertically() {
        self.transform = CGAffineTransform(scaleX: transformedX, y: transformedY * -1)
    }

    @objc
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.superview!)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        gestureRecognizer.setTranslation(.zero, in: self.superview!)
    }

    @objc
    func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        self.transform = self.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        gestureRecognizer.scale = 1
    }

    @objc
    func handleRotation(gestureRecognizer: UIRotationGestureRecognizer) {
        self.transform = self.transform.rotated(by: gestureRecognizer.rotation)
        gestureRecognizer.rotation = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
