//
//  MenuItemsViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/7/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

class MenuItemsViewController: FetchedResultsViewController {
    
    // MARK: - Properties
    
    let numberFormatter: NSNumberFormatter = {
       
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        return numberFormatter
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set fetch request
        let fetchRequest = NSFetchRequest(entityName: "MenuItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        self.fetchRequest = fetchRequest
    }
    
    // MARK: - Methods
    
    override func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.MenuItemCell.rawValue, forIndexPath: indexPath) as UITableViewCell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        
        if error != nil {
            
            // TODO: Configure cell for error
            
        }
        
        // get model object
        let menuItem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as MenuItem
        
        let dateCached = menuItem.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
        // not cached
        
        if dateCached == nil {
            
            // configure empty cell... 
            
            cell.textLabel!.text = NSLocalizedString("Loading...", comment: "Loading...")
            
            cell.detailTextLabel!.text = ""
            
            cell.userInteractionEnabled = false
            
            return
        }
        
        // configure cell...
        
        cell.userInteractionEnabled = true
        
        cell.textLabel!.text = menuItem.name
        
        // build price text
        
        self.numberFormatter.locale = NSLocale(localeIdentifier: menuItem.currencyLocaleIdentifier)
        
        cell.detailTextLabel!.text = self.numberFormatter.stringFromNumber(menuItem.price)
        
        // fix detail text label not showing
        cell.layoutIfNeeded()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let segueIdentifier = MainStoryboardSegueIdentifier(rawValue: segue.identifier!)!
        
        switch segueIdentifier {
            
        case .ShowMenuItem:
            
            // get destination VC
            let menuItemVC = segue.destinationViewController as MenuItemViewController
            
            // get model object
            let menuItem = self.fetchedResultsController!.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as MenuItem
            
            // configure VC
            menuItemVC.managedObject = menuItem
            
            // set edit handler
            menuItemVC.didEditManagedObjectHandler = {
                
                // pop VC
                self.navigationController!.popViewControllerAnimated(true)
                
                return
            }
            
        case .NewMenuItem:
            
            return
            
        default:
            return
        }
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case MenuItemCell = "MenuItemCell"
}
