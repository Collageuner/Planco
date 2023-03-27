//
//  BingCodes.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/03/07.
//

import UIKit

/*
 

class ViewController: UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rotate image by 45 degrees
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        
        // Resize image to 100 x 100
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // Use autoresizingMask to adjust layout
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat.pi)
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat.pi
        }

        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()

        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);

        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees));

        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat

        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }

       bitmap?.scaleBy(x: yFlip, y: -1.0)
       bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         // Scale up by 50%
         imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

         // Stretch horizontally only
         imageView.transform = CGAffineTransform(scaleX: 2, y: 1)

         // Move right by 100 points and down by 200 points
         imageView.transform = CGAffineTransform(translationX: 100, y: 200)

         // Rotate by pi/4 radians (45 degrees)
         imageView.transform = CGAffineTransform(rotationAngle:.pi / 4)
    }
}

extension UIImage {
    func rotate (radians : Float) -> UIImage? {
        
      var newSize : CGSize!
      let rect   : CGRect!
      var radius : Double!
      
      radius               = Double(radians)
      rect                 = CGRect(origin:CGPoint.zero,size:self.size)
      newSize              = CGSize(width:self.size.width ,height:self.size.height)
      UIGraphicsBeginImageContext(newSize!)
      
      let context : CGContext!     = UIGraphicsGetCurrentContext()
      
      context.translateBy(x:newSize!.width/2,y:newSize!.height/2 )
      
      context.rotate(by:radians )
      
      self.draw(in:CGRect(x:-self.size.width/2,y:-self.size.height/2,width:self.size.width,height:self.size.height))
      
      let newImage : UIImage!     = UIGraphicsGetImageFromCurrentImageContext()
      
      UIGraphicsEndImageContext()
        
     return newImage
        
   }
}

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        
        // Add it to the image view
        imageView.addGestureRecognizer(pinchGesture)
        
        // Enable user interaction for the image view
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func pinchAction(_ gesture: UIPinchGestureRecognizer) {
        // Get the current scale factor
        let scale = gesture.scale
        
        // Apply it to the image view's transform
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}


*/


/*   ⚠️ USAGE
 let thumbnailSize = CGSize(width: 80, height: 80)
 let scaledImage = image.scalePreservingAspectRatio(targetSize: thumbnailSize)
 
 ...
 
 guard let thumbnailImageData = scaledImage.pngData() else {
 print("Failed to Compress Image into thumbnail Image")
 return
 }
 */

/// We'll be using OpenCV... So... but We can study the codes though.
/// ⚠️ Code that smoothing Edges Failed, and none of them works fine....
//    func smoothed(withRadius radius: CGFloat) -> UIImage? {
//        let imageRect = CGRect(origin: .zero, size: size)
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        context.scaleBy(x: 1, y: -1)
//        context.translateBy(x: 0, y: -size.height)
//        context.setBlendMode(.normal)
//        let rectPath = UIBezierPath(roundedRect: imageRect.insetBy(dx: radius, dy: radius), cornerRadius: radius)
//        rectPath.addClip()
//        draw(in: imageRect)
//        context.drawLinearGradient(CGGradient(colorsSpace: nil, colors: [UIColor.clear.cgColor, UIColor.black.cgColor] as CFArray, locations: [0, 1])!, start: CGPoint(x: 0, y: size.height - radius), end: CGPoint(x: 0, y: size.height), options: []
//        )
//        let smoothedImage = UIGraphicsGetImageFromCurrentImageContext()
//        return smoothedImage
//    }

//func smoothing() {
//    let path = UIBezierPath(roundedRect: selectedImageView.bounds, cornerRadius: 20)
//    let maskLayer = CAShapeLayer()
//    maskLayer.path = path.cgPath
//    selectedImageView.layer.mask = maskLayer
//}
//
//func putFeatherEffect(image: UIImage?, radius: CGFloat) -> UIImage? {
//    guard let inputImage = image else {
//        print("🧷 1")
//        return UIImage() }
//    let context = CIContext()
//    guard let ciImage = CIImage(image: inputImage) else {
//        print("🧷 2")
//        return UIImage()}
//    guard let filter = CIFilter(name: "CIGaussianBlur") else {
//        print("🧷 3")
//        return UIImage()}
//    filter.setValue(ciImage, forKey: kCIInputImageKey)
//    filter.setValue(radius, forKey: kCIInputRadiusKey)
//    guard let outputCiImage = filter.outputImage else {
//        print("🧷 4")
//        return UIImage()}
//
//    let mask = CIImage(color: CIColor(red: 1, green: 1, blue: 1, alpha: 0))
//    guard let maskFilter = CIFilter(name: "CIRadialGradient") else {
//        print("🧷 5")
//        return UIImage()}
//    maskFilter.setValue(CIVector(x: inputImage.size.width/2, y: inputImage.size.height/2), forKey: "inputCenter")
//    maskFilter.setValue(inputImage.size.width/2 * 0.9, forKey: "inputRadius0")
//    maskFilter.setValue(inputImage.size.width/2 * 1.1, forKey: "inputRadius1")
//    let maskOutputCIImage = maskFilter.outputImage!.cropped(to: ciImage.extent)
//
//    let invertedMask = maskOutputCIImage.applyingFilter("CIColorInvert")
//
//    let maskedOutputCIImage = outputCiImage.applyingFilter("CIBlendWithMask", parameters: [kCIInputMaskImageKey: invertedMask])
//
//
//    let cgImage = context.createCGImage(maskedOutputCIImage, from: maskedOutputCIImage.extent)!
//    let outputImage = UIImage(cgImage: cgImage)
//
//    return outputImage
//}
