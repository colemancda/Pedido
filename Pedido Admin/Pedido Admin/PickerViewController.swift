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
        
        self.tableView.editing = true
    }
    
    // MARK: - Methods
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError?) {
        super.configureCell(cell, atIndexPath: indexPath, withError: error)
        
        if error != nil {
            
            // TODO: handle error
            
            return
        }
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
        
        // set editing accesory
        if (selectedItems as NSArray).containsObject(managedObject) {
            
            cell.editingAccessoryType = .Checkmark
        }
        else {
            
            cell.editingAccessoryType = .None
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !self.editing {
            
            return
        }
        
        self.updateSelection()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !self.editing {
            
            return
        }
        
        self.updateSelection()
    }
    
    // MARK: - Private Methods
    
    private func updateSelection() {
        
        // get model object from selected indexes...
        
        var selectedItems = [NSManagedObject]()
        
        for indexPath in tableView.indexPathsForSelectedRows() as [NSIndexPath] {
            
            // get model object
            let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
            
            selectedItems.append(managedObject)
        }
        
        self.selectedItems = selectedItems
        
        self.selectionHandler?()
    }
}

