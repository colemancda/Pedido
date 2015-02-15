//
//  OrdersRelationshipViewController.swift
//  PedidoAdmin
//
//  Created by Alsey Coleman Miller on 2/15/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

class OrdersRelationshipViewController: RelationshipViewController {
    
    // MARK: - Methods
    
    override func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.OrderCell.rawValue, forIndexPath: indexPath) as UITableViewCell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        
        if error != nil {
            
            // TODO: Configure cell for error
            
            return
        }
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as LocalizedText
        
        // check if fully downloaded
        let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
        // not cached
        if dateCached == nil {
            
            // configure empty cell...
            
            localizedDescriptionCell.languageLabel.text = NSLocalizedString("Loading...", comment: "Loading...")
            
            localizedDescriptionCell.descriptionLabel.text = ""
            
            cell.userInteractionEnabled = false
            
            return
        }
        
        // configure cell...
        
        cell.userInteractionEnabled = true
        
        localizedDescriptionCell.languageLabel.text = (managedObject.locale as NSString).uppercaseString
        
        localizedDescriptionCell.descriptionLabel.text = managedObject.text
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case OrderCell = "OrderCell"
}
