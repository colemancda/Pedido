//
//  ManagedObjectViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/11/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

/** Abstract class for editing a managed object. */
class ManagedObjectViewController: UITableViewController {
    
    // MARK: - Properties
    
    var managedObject: NSManagedObject? {
        
        didSet {
            
            if self.isViewLoaded() {
                
                self.updateUI()
            }
        }
    }
    
    // MARK: Action Blocks
    
    var didEditManagedObjectHandler: (() -> Void)?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.updateUI()
    }
    
    // MARK: - Methods
    
    /** Subclasses should overrride this to extract the new values from the UI. Returning nil indicates that the UI was provided with invalid values or could not get them at this time. */
    func getNewValues() -> [String: AnyObject]? {
        
        return nil
    }
    
    /** Subclasses should override this to configure the UI with the values provided from the managedObject. */
    func configureUI(forManagedObject managedObject: NSManagedObject) {
        
    }
    
    /** Subclasses should override this to reset the UI to an empty state. */
    func resetUI() {
        
        
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        
        // reset UI
        if self.managedObject == nil {
            
            self.resetUI()
            
            return
        }
        
        // configure UI for managed object
        self.configureUI(forManagedObject: self.managedObject!)
    }
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
        
        let newValues = self.getNewValues()
        
        if newValues == nil {
            
            return
        }
        
        // update existing menu item
        
        Store.sharedStore.editManagedObject(self.managedObject!, changes: newValues!, completionBlock: { (error) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.save(self)
                    })
                    
                    return
                }
                
                self.didEditManagedObjectHandler?()
            })
        })
    }
}

