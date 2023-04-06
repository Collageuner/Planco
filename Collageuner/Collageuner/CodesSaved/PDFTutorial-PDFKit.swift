//
//  PDFTutorial.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/04/06.
//

//import PDFKit
import UIKit
import PDFKit

public func saveImageToCanvasImagePDF(canvasImage image: UIImage) {
    let fileManager = FileManager.default
    guard let originalDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: DirectoryForWritingData.GardenOriginalImages.dataDirectory) else {
        print("Failed fetching directory for Images for Garden Image")
        return
    }
    
    
}
let documentURL = URL(string: "") // URL to your PDF document.

// Create a `PDFDocument` object using the URL.
let pdfDocument = PDFDocument(url: documentURL!)!

// `page` is of type `PDFPage`.
let page = pdfDocument.page(at: 0)!

 // Extract the crop box of the PDF. We need this to create an appropriate graphics context.
let bounds = page.bounds(for: .cropBox)

// Create a `UIGraphicsImageRenderer` to use for drawing an image.
let renderer = UIGraphicsImageRenderer(bounds: bounds, format: UIGraphicsImageRendererFormat.default())

// This method returns an image and takes a block in which you can perform any kind of drawing.
let image = renderer.image { (context) in
    // We transform the CTM to match the PDF's coordinate system, but only long enough to draw the page.
    context.cgContext.saveGState()

    context.cgContext.translateBy(x: 0, y: bounds.height)
    context.cgContext.concatenate(CGAffineTransform.init(scaleX: 1, y: -1))
    page.draw(with: .mediaBox, to: context.cgContext)

    context.cgContext.restoreGState()

    let myImage = ... // A `UIImage` object of the image you want to draw.

    let imageRect = ... // `CGRect` for the image.

    // Draw your image onto the context.
    myImage.draw(in: imageRect)
}

// Create a new `PDFPage` with the image that was generated above.
let newPage = PDFPage(image: image)!

// Add the existing annotations from the existing page to the new page we created.
for annotation in page.annotations {
    newPage.addAnnotation(annotation)
}

// Insert the newly created page at the position of the original page.
pdfDocument.insert(newPage, at: 0)

// Remove the original page.
pdfDocument.removePage(at: 1)

// Save the document changes.
pdfDocument.write(toFile: filePath)
