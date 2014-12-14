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

class PickerViewController: FetchedResultsViewController {
    
    // MARK: - Properties
    
    var selectedItems = [NSManagedObject]()
    
    var selectionHandler: (() -> Void)?
    
    var allowsMultipleSelection: Bool {
        
        get {
            return self.tableView.allowsMultipleSelection
        }
        
        set {
            
            self.tableView.allowsMultipleSelection = allowsMultipleSelection
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // MARK: - Methods
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        super.configureCell(cell, atIndexPath: indexPath, withError: error)
        
        // set cell selection...
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
        
        if (self.selectedItems as NSArray).containsObject(managedObject) {
            
            cell.accessoryType = .Checkmark
        }
        else {
            
            cell.accessoryType = .None
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
        
        // add to selected items...
        if !(self.selectedItems as NSArray).containsObject(managedObject) {
            
            self.selectedItems.append(managedObject)
            
            self.selectionHandler?()
        }
    }
}