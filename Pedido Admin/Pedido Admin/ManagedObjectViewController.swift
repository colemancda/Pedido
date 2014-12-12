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

class ManagedObjectViewController: UITableViewController {
    
    // MARK: - Properties
    
    var entityName: String?
    
    var managedObject: NSManagedObject? {
        
        didSet {
            
            self.entityName = managedObject?.entity.name!
            
            if self.isViewLoaded() {
                
                self.updateUI()
            }
        }
    }
    
    var delegate: ManagedObjectViewControllerDelegate?
    
    var cancelButtonEnabled: Bool = false {
        
        didSet {
            
            if cancelButtonEnabled {
                
                // add cancel button
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
            }
            
            else {
                
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    /** Subclasses should override this to reset to UI to an empty state. */
    func resetUI() {
        
    }
    
    // MARK: - Private Methods
    
    func updateUI() {
        
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
        
        // create new menu item
        if self.managedObject == nil {
            
            assert(self.entityName != nil, "Entity name is nil")
            
            Store.sharedStore.createEntity(self.entityName!, withInitialValues: newValues, completionBlock: { (error, managedObject) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    // show error
                    if error != nil {
                        
                        self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                            
                            self.save(self)
                        })
                        
                        return
                    }
                    
                    self.delegate?.managedObjectViewController(self, didCreateManagedObject: managedObject!)
                })
            })
            
            return
        }
        
        // update existing menu item
        
        assert(self.entityName == self.managedObject!.entity.name!, "Entity name does not match managed object's entity name")
        
        Store.sharedStore.editManagedObject(self.managedObject!, changes: newValues!, completionBlock: { (error) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.save(self)
                    })
                    
                    return
                }
                
                self.delegate?.managedObjectViewController(self, didEditManagedObject: self.managedObject!)
            })
        })
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.delegate?.managedObjectViewControllerDidCancel(self)
    }
}

// MARK: - Protocols

protocol ManagedObjectViewControllerDelegate {
    
    func managedObjectViewController(managedObjectViewController: ManagedObjectViewController, didEditManagedObject managedObject: NSManagedObject)
    
    func managedObjectViewController(managedObjectViewController: ManagedObjectViewController, didCreateManagedObject managedObject: NSManagedObject)
    
    func managedObjectViewControllerDidCancel(managedObjectViewController: ManagedObjectViewController)
}

