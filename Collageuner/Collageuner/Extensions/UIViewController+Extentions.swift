//
//  UIViewController+Extentions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/14.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif

/* Usage:
 
 #if canImport(SwiftUI) && DEBUG
 import SwiftUI

 struct PlanViewController_PreViews: PreviewProvider {
     static var previews: some View {
         PlanViewController().toPreview()
     }
 }
 #endif
 
 */
