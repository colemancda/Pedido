//
//  NewImageViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/17/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import JTSImage

class NewImageViewController: NewManagedObjectViewController, UIImagePickerControllerDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    override var entityName: String {
        
        return "Image"
    }
    
    var parentManagedObject: (NSManagedObject, String)!
    
    /** The data of the new image. Do not set this to nil. */
    var imageData: NSData? {
        
        didSet {
            
            self.imageView.image = UIImage(data: imageData!)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tappedImageView(sender: UIGestureRecognizer) {
        
        // table view cell...
        let imageView = sender.view as UIImageView
        
        if imageView.image != nil {
            
            // create image info
            let imageInfo = JTSImageInfo()
            imageInfo.image = imageView.image!
            imageInfo.referenceRect = imageView.frame
            imageInfo.referenceView = imageView.superview!
            
            // create image VC
            let imageVC = JTSImageViewController(imageInfo: imageInfo,
                mode: JTSImageViewControllerMode.Image,
                backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
            
            // present VC
            imageVC.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOriginalPosition)
        }
        
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        
        // detect no camera
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) == nil && UIImagePickerController.availableCaptureModesForCameraDevice(.Front) == nil {
            
            self.showErrorAlert(NSLocalizedString("No Camera", comment: "No Camera"))
            
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        self.presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.barButtonItem = sender
    }
    
    // MARK: - Methods
    
    override func getNewValues() -> [String : AnyObject]? {
        
        // no image set
        if self.imageData == nil {
            
            self.showErrorAlert(NSLocalizedString("Must set image.", comment: "Must set image."))
            
            return nil
        }
        
        // relationship
        let (managedObject, parentManagedObjectKey) = self.parentManagedObject
        
        return ["data": self.imageData!, parentManagedObjectKey: managedObject]
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
    }
}