//
//  ViewController.swift
//  HighFlexDemo
//
//  Created by Sam Green on 4/11/22.
//

import UIKit
import BerbixAdvanced
import AVFoundation

class SessionViewController: UIViewController {
    @IBOutlet weak var captureButton: UIButton!
    
    let session = CameraSession()
    let outlineView = UIView()
    let detailLabel = UILabel()
    var requestedMode: CameraSession.Mode = .application
    
    @IBAction func requestManualCapture(_ sender: Any) {
        session.capturePhoto()
        if #available(iOS 15.0, *) {
            captureButton.configuration?.showsActivityIndicator = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the session preview below the button
        view.insertSubview(session.sessionView, belowSubview: captureButton)
        configureOutlineView()
        configureDetailsLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSession()
        print("Starting in mode \(session.currentMode)")
        captureButton.isHidden = session.isAutoCaptureEnabled
        /// Start the session automatically when this view controller appears
        session.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 15.0, *) {
            captureButton.configuration?.showsActivityIndicator = false
        }
        /// Stop the session automatically when this view controller disappears
        session.stop()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        session.sessionView.frame = view.bounds
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showCapturePhoto",
           let destination = segue.destination as? PhotoCaptureViewController,
           let photo = sender as? AVCapturePhoto {
            destination.capturedPhoto = photo
        }
    }
    
    func configureOutlineView() {
        // Set up our visual outline view
        outlineView.layer.borderColor = UIColor.blue.cgColor
        outlineView.layer.borderWidth = 1.0
        outlineView.layer.backgroundColor = UIColor.clear.cgColor
        outlineView.layer.cornerRadius = 16.0
        outlineView.layer.masksToBounds = true
        
        // Add our outline view as a subview of the preview view
        session.sessionView.addSubview(outlineView)
    }
    
    func configureDetailsLabel() {
        detailLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        detailLabel.allowsDefaultTighteningForTruncation = true
        detailLabel.showsExpansionTextWhenTruncated = true
        detailLabel.text = "Details Label"
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailLabel)
        
        let margins = view.layoutMarginsGuide
        detailLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func configureSession() {
        /// Move the outline view so it corresponds to the **document** in the frame
        session.onDocumentDetected = { frame in
            self.outlineView.frame = frame
        }
        /// Move the outline view so it corresponds to the **barcode** in the frame
        session.onBarcodeDetected = { frame, barcodeDataString in
            self.outlineView.frame = frame
            self.detailLabel.text = barcodeDataString
        }
        /// Move the outline view so it corresponds to the **face** in the frame
        session.onFaceDetected = { frame, faceYaw in
            self.outlineView.frame = frame
            self.detailLabel.text = "Face Angle: \(round(faceYaw))°"
        }
        /// Handle the image that was captured by the session
        session.onPhotoTaken = { photo in
            print("Successfully captured photo! Details \(photo)")
            self.performSegue(withIdentifier: "showCapturePhoto", sender: photo)
        }
        /// Finally pass the requested mode on to the session so we're ready to call
        /// `start()` on the session
        try? session.configureFor(mode: requestedMode, enableAutoCapture: false)
    }
}

