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
    
    // MARK: - Private Properties
    
    var datedRefreshed: NSDate?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var error: NSError?
        
        self.fetchedResultsController.performFetch(&error)
        
        assert(error == nil, "Could not execute -performFetch: on NSFetchedResultsController. (\(error!.localizedDescription))")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // reload data on appear
        self.refresh(self)
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(sender: AnyObject) {
        
        self.datedRefreshed = NSDate()
        
        Store.sharedStore.performSearch(self.fetchedResultsController.fetchRequest, completionBlock: { (error, results) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.refreshControl!.endRefreshing()
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.refresh(self)
                    })
                    
                    return
                }
                
                self.tableView.reloadData()
            })
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.MenuItemCell.rawValue, forIndexPath: indexPath) as UITableViewCell
        
        // configure cell
        self.configureCell(cell, atIndexPath: indexPath)
        
        // fetch from server... (loading table view after -refresh:)
        
        if self.datedRefreshed != nil {
            
            // get model object
            let menuItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as MenuItem
            
            // get date cached
            let dateCached = menuItem.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
            
            // fetch if older than refresh date
            if dateCached == nil || dateCached?.compare(self.datedRefreshed!) == NSComparisonResult.OrderedDescending {
                
                Store.sharedStore.fetchEntity("MenuItem", resourceID: menuItem.valueForKey(Store.sharedStore.resourceIDAttributeName) as UInt, completionBlock: { (error, managedObject) -> Void in
                    
                    // configure error cell
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        
                        if error != nil {
                            
                            // get cell for error request (may have changed)
                            
                            // TODO: handle error (show error text in cell)
                        }
                    })
                    
                    // fetched results controller should update cell
                })
            }
        }
        
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
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                    
                    self.configureCell(cell, atIndexPath: indexPath)
                }
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
        
        self.numberFormatter.locale = menuItem.currencyLocale
        
        cell.detailTextLabel!.text = self.numberFormatter.stringFromNumber(menuItem.price)
        
        // fix detail text label not showing
        cell.layoutIfNeeded()
    }
    
    // MARK: - Segues
    
    @IBAction func savedMenuItem(sender: UIStoryboardSegue) {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let segueIdentifier = MainStoryboardSegueIdentifier(rawValue: segue.identifier!)!
        
        switch segueIdentifier {
            
        case .ShowMenuItem:
            
            // get destination VC
            let menuItemVC = segue.destinationViewController as MenuItemViewController
            
            // get model object
            let menuItem = self.fetchedResultsController.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as MenuItem
            
            // configure VC
            menuItemVC.menuItem = menuItem
            
        case .NewMenuItem:
            
            // get destination VC
            let menuItemVC = (segue.destinationViewController as UINavigationController).topViewController as MenuItemViewController
            
            // add cancel button
            menuItemVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: menuItemVC, action: "cancel:")            
            
        default:
            return
        }
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case MenuItemCell = "MenuItemCell"
}
