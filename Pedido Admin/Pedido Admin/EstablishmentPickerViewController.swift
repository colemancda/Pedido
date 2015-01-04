//
//  EstablishmentPickerViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/13/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

class EstablishmentPickerViewController: PickerViewController {
    
    // MARK: - Properties
    
    override var relationship: (NSManagedObject, String)? {
        
        didSet {
            
            super.relationship = relationship
            
            if self.relationship != nil {
                
                // set fetch request
                let fetchRequest = NSFetchRequest(entityName: "Establishment")
                
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
                
                self.fetchRequest = fetchRequest
            }
        }
    }
    
    // MARK: - Methods
    
    override func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.EstablishmentCell.rawValue, forIndexPath: indexPath) as UITableViewCell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        
        if error != nil {
            
            // TODO: Configure cell for error
            
            return
        }
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as Establishment
        
        // check if fully downloaded
        let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
        // not cached
        if dateCached == nil {
            
            // configure empty cell...
            
            cell.textLabel!.text = NSLocalizedString("Loading...", comment: "Loading...")
            
            cell.userInteractionEnabled = false
            
            return
        }
        
        // configure cell...
        
        cell.userInteractionEnabled = true
        
        cell.textLabel!.text = managedObject.location
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case EstablishmentCell = "EstablishmentCell"
}

