//
//  PhotoCaptureViewController.swift
//  HighFlexDemo
//
//  Created by Sam Green on 4/11/22.
//

import Foundation
import UIKit
import AVFoundation

class PhotoCaptureViewController: UIViewController {
    var capturedPhoto: AVCapturePhoto?
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cgPhoto = capturedPhoto?.cgImageRepresentation() {
            photoImageView.image = UIImage(cgImage: cgPhoto)
        }
    }
}
