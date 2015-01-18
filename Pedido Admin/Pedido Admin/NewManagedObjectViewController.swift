//
//  NewManagedObjectViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/25/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CorePedido
import CorePedidoClient

/** Abstract class for creating a new managed object. */
class NewManagedObjectViewController: UITableViewController {
    
    // MARK: - Properties
    
    /** Name of the entity to be created. */
    var entityName: String {
        
        return ""
    }

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // add buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done:")
    }
    
    // MARK: - Methods
    
    /** Subclasses should overrride this to extract the new values from the UI. Returning nil indicates that the UI was provided with invalid values or could not get them at this time. */
    func getNewValues() -> [String: AnyObject]? {
        
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        
        let newValues = self.getNewValues()
        
        if newValues == nil {
            
            return
        }
        
        // create entity
        
        Store.sharedStore.createEntity(self.entityName, withInitialValues: newValues, completionBlock: { (error, managedObject) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.done(self)
                    })
                    
                    return
                }
                
                // dismiss VC
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        })
    }
}