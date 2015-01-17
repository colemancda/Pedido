//
//  ImagesRelationshipViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/16/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient
import JTSImage
import ColorCube

class ImagesRelationshipViewController: RelationshipViewController {
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    // MARK: - Actions
    
    @IBAction func tappedImageView(sender: UIGestureRecognizer) {
        
        let imageView = sender.view as UIImageView
        
        if imageView.image != nil {
            
            // create image info
            let imageInfo = JTSImageInfo()
            imageInfo.image = imageView.image!
            imageInfo.referenceRect = imageView.frame
            imageInfo.referenceView = imageView.superview
            imageInfo.referenceContentMode = imageView.contentMode
            
            // create image VC
            let imageVC = JTSImageViewController(imageInfo: imageInfo,
                mode: JTSImageViewControllerMode.Image,
                backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
            
            // present VC
            imageVC.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOriginalPosition)
        }
        
    }
    
    // MARK: - Methods
    
    override func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ImageCell.rawValue, forIndexPath: indexPath) as ImageTableViewCell
        
        // set image tap gesture recognizer
        if cell.tapGestureRecognizer == nil {
            
            cell.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedImageView:")
            
            cell.largeImageView.addGestureRecognizer(cell.tapGestureRecognizer!)
        }
        
        // adjust insets
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        
        let imageCell = cell as ImageTableViewCell
        
        if error != nil {
            
            // TODO: Configure cell for error
            
            // set background to red
            imageCell.backgroundColor = UIColor.redColor()
            
            return
        }
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as Image
        
        // check if fully downloaded
        let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
        // not cached
        if dateCached == nil {
            
            // configure empty cell...
            
            // imageCell.textLabel?.text = NSLocalizedString("Loading...", comment: "Loading...")
            
            imageCell.largeImageView.image = nil
            
            imageCell.activityIndicatorView.hidden = false
            
            imageCell.activityIndicatorView.startAnimating()
            
            // make light grey if even row
            if (indexPath.row % 2) == 0 {
                
                imageCell.backgroundColor = UIColor(white: 0.7, alpha: 0.95)
            }
            
            // darker grey
            else {
                
                imageCell.backgroundColor = UIColor(white: 0.8, alpha: 0.95)
            }
            
            cell.userInteractionEnabled = false
            
            return
        }
        
        // configure cell...
        
        cell.userInteractionEnabled = true
        
        let image = UIImage(data: managedObject.data)!
        
        imageCell.largeImageView.image = image
        
        let dominantColor: UIColor = {
            
            let colorCube = CCColorCube()
            
            let colors = colorCube.extractColorsFromImage(image, flags: 0) as [UIColor]
            
            return colors.first ?? UIColor.whiteColor()
        }()
        
        imageCell.backgroundColor = dominantColor
        
        imageCell.activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .NewImage:
            
            let newImageVC = (segue.destinationViewController as UINavigationController).topViewController as NewImageViewController
            
            let (parentManagedObject, key) = self.relationship!
            
            // get relationship description
            let relationshipDescription = parentManagedObject.entity.relationshipsByName[key] as NSRelationshipDescription
            
            newImageVC.parentManagedObject = (parentManagedObject, relationshipDescription.inverseRelationship!.name)
            
        default:
            return
        }
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case ImageCell = "ImageCell"
}

// MARK: - Supporting Classes

class ImageTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var largeImageView: UIImageView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var tapGestureRecognizer: UITapGestureRecognizer?
}