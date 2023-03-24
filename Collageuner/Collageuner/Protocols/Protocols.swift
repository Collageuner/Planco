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
    func fetchImageFromGarage(garageImage: UIImage)
}
    /// Reload the tableViews as Adding Task finishes
protocol AddPlanDelegate: AnyObject {
    func reloadTableViews()
}

    /// Reload the tableView with GarageViewcController subscribing GarageImagesViewModel
protocol GarageViewDelegate: AnyObject {
    func reloadTableViews()
}
