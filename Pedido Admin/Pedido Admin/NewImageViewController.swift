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

class NewImageViewController: NewManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    override var entityName: String {
        
        return "Image"
    }
    
    var parentManagedObject: (NSManagedObject, String)!
    
    // MARK: - Actions
    
    @IBAction func tappedImageView(sender: UIGestureRecognizer) {
        
        let imageView = sender.view as UIImageView
        
        
        
    }
}