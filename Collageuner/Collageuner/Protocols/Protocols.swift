//
//  Protocols.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/31.
//

import UIKit

import RxSwift
import RxCocoa

    /// Passes Image selected from Garage List to Parent ViewController
protocol GarageSheetDelegate: AnyObject {
    func fetchImageFromGarageSheet(garageImage: UIImage)
}
    /// Reload the tableViews as Adding Task finishes
protocol AddPlanDelegate: AnyObject {
    func reloadTableViews()
}

    /// Reload the tableView with GarageViewcController subscribing GarageImagesViewModel Or Passes Image selected from GalleryView to TaskCompleteImage ViewController
@objc
protocol GarageViewDelegate: AnyObject {
    @objc optional func reloadTableViews()
    @objc optional func fetchImage(selectedImageData: Data)
}

protocol StickerViewDelegate: AnyObject {
    func stickerViewDidBeginMoving(_ stickerView: StickerView)
    func stickerViewDidChangeMoving(_ stickerView: StickerView)
    func stickerViewDidEndMoving(_ stickerView: StickerView)
    func stickerViewDidBeginRotating(_ stickerView: StickerView)
    func stickerViewDidChangeRotating(_ stickerView: StickerView)
    func stickerViewDidEndRotating(_ stickerView: StickerView)
    func stickerViewDidTap(_ stickerView: StickerView)
}
