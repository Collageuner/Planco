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
