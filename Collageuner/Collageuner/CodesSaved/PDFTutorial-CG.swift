//
//  PDFTutorial-CG.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/04/06.
//

import UIKit
public func AddImageToPDFUsingCG() {
    let documentURL = URL(string: "")!
    
    // Create a `CGPDFDocument` object for accessing the PDF pages.
    // We need these pages in order to draw the original/existing content, because `UIGraphicsBeginPDFContextToFile` creates a file with a clean slate.
    // We will have the original file contents in memory as long as the `CGPDFDocument` object is around, even after we have started rewriting the file at the path.
    guard let originalDocument = CGPDFDocument(documentURL as CFURL) else {
        print("Unable to create read document.")
        return
    }
    
    // Create a new PDF at the same path to draw the contents into.
    UIGraphicsBeginPDFContextToFile(documentURL.path, CGRect.zero, nil)
    
    let image = UIImage(named: "my_image_name")!
    
    guard let pdfContext = UIGraphicsGetCurrentContext() else {
        print("Unable to access PDF Context.")
        return
    }
    
    let pageSize = UIGraphicsGetPDFContextBounds().size
    
    for pageIndex in 0..<originalDocument.numberOfPages {
        
        // Mark the beginning of the page.
        pdfContext.beginPDFPage(nil)
        
        // Pages are numbered starting from 1.
        // Access the `CGPDFPage` object with the original contents.
        guard let currentPage = originalDocument.page(at: pageIndex + 1) else {
            return
        }
        
        // Draw the existing page contents.
        pdfContext.drawPDFPage(currentPage)
        
        // Save the context state to restore after we are done drawing the image.
        pdfContext.saveGState()
        
        // Change the PDF context to match the UIKit coordinate system.
        pdfContext.translateBy(x: 0, y: pageSize.height)
        pdfContext.scaleBy(x: 1, y: -1)
        
        
        // Location of the image to be drawn in UIKit coordinates.
        let imagePosition = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.draw(in: imagePosition)
        
        // Restoring the context back to its original state.
        pdfContext.restoreGState()
        
        // Mark the end of the current page.
        pdfContext.endPDFPage()
    }
    
    // End the PDF context, essentially closing the PDF document context.
    UIGraphicsEndPDFContext()
}
