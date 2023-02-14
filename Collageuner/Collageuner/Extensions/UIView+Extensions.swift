//
//  UIView+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
      for view in views {
        self.addSubview(view)
      }
    }
    
    // View 를 저장하나의 이미지로 저장하는 방법
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        // 메모리 peak 에 대해서도 한번 살펴봐보자. 분기를 나눴던 코드에 대해서는 괜찮았는데, 바로 이 코드를 사용해보니
        // self.drawHierarchy(in: self.bounds, afterScreenUpdates: true) 를 쓰다가 안됐는데 이걸 쓰니깐 잘 된다. drawHierarchy 를 검색해보자.
    }
    
    /*
     To change the sequence of subviews in a parent view in Swift, you can use the insertSubview(_:at:), exchangeSubview(at:withSubviewAt:), bringSubviewToFront(_:), and sendSubviewToBack(_:) methods provided by the UIView class.
     */
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

/* Usage:
 
 #if canImport(SwiftUI) && DEBUG
 import SwiftUI

 struct MyViewPreview: PreviewProvider{
     static var previews: some View {
         UIViewPreview {
             return PlanFirstGuideView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
         }.previewLayout(.sizeThatFits)
     }
 }
 #endif
 
 */
