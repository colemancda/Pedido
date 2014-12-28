//
//  PickerViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/10/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

/** View controller for editing to-many relationships between entities. It allows selection from a list of existing items. */
class PickerViewController: FetchedResultsViewController {
    
    // MARK: - Properties
    
    var relationship: ToManyRelationship?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.editing = true
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
        
        let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        // only configure editing accesory if managed object was cached
        
        if dateCached != nil {
            
            // configure editing accessory
            
            if self.relationship!.isMember(managedObject) {
                
                cell.editingAccessoryType = .Checkmark
            }
            else {
                
                cell.editingAccessoryType = .None
            }
            
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        if !self.editing {
            
            return
        }
        
        // remove or add to relationship
        
        self.relationship!.managedObject.valueForKey(<#key: String#>)
        
        
    }
}


