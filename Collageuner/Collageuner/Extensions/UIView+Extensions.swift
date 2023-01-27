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
    
}
