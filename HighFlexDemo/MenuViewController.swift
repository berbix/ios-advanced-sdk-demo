//
//  MenuViewController.swift
//  HighFlexDemo
//
//  Created by Sam Green on 4/12/22.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = segue.identifier
        if let destination = segue.destination as? SessionViewController {
            switch name {
            case "startDocument": destination.requestedMode = .document
            case "startBarcode": destination.requestedMode = .barcodeOnly
            case "startSelfie": destination.requestedMode = .selfie
            case "startApp": destination.requestedMode = .application
            default: return
            }
        }
    }
}
