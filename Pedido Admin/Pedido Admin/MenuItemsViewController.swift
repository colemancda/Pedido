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

class MenuItemsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    let numberFormatter: NSNumberFormatter = {
       
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        return numberFormatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "MenuItem")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CorePedidoClient.Store.sharedStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // reload data on appear
        self.reloadData(self)
    }
    
    // MARK: - Actions
    
    @IBAction func reloadData(sender: AnyObject) {
        
        Store.sharedStore.performSearch(self.fetchedResultsController.fetchRequest, completionBlock: { (error, results) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.refreshControl!.endRefreshing()
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.reloadData(self)
                    })
                    
                    return
                }
            })
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.MenuItemCell.rawValue, forIndexPath: indexPath) as UITableViewCell
        
        
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                self.configureCell(cell!, atIndexPath: indexPath)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            default:
                return
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    // MARK: - Private Methods
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get model object
        let menuItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as MenuItem
        
        // configure cell...
        
        cell.textLabel!.text = menuItem.name
        
        // build price text
        
        self.numberFormatter.locale = menuItem.currencyLocale
        
        cell.detailTextLabel!.text = self.numberFormatter.stringFromNumber(menuItem.price)
    }
    
    // MARK: - Segues
    
    @IBAction func savedMenuItem(sender: UIStoryboardSegue) {
        
        
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case MenuItemCell = "MenuItemCell"
}
