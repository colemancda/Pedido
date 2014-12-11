//
//  FetchedResultsViewController.swift
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

/** Fetches instances of an entity on the server and displays them in a table view. */
class FetchedResultsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    var fetchRequest: NSFetchRequest? {
        
        didSet {
            
            if fetchRequest == nil {
                
                return
            }
            
            // create new fetched results controller
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: Store.sharedStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self
            
            self.fetchedResultsController = fetchedResultsController
            
            // perform fetch if view is loaded
            if self.isViewLoaded() {
                
                var error: NSError?
                
                self.fetchedResultsController?.performFetch(&error)
                
                assert(error == nil, "Could not execute -performFetch: on NSFetchedResultsController. (\(error!.localizedDescription))")
                
                // load from server
                self.refresh(self)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var datedRefreshed: NSDate?
    
    private var fetchedResultsController: NSFetchedResultsController?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var error: NSError?
        
        self.fetchedResultsController?.performFetch(&error)
        
        assert(error == nil, "Could not execute -performFetch: on NSFetchedResultsController. (\(error!.localizedDescription))")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload data on appear
        self.refresh(self)
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(sender: AnyObject) {
        
        self.datedRefreshed = NSDate()
        
        Store.sharedStore.performSearch(self.fetchRequest!, completionBlock: { (error, results) -> Void in
            
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
        
        return self.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.dequeueReusableCellForIndexPath(indexPath) as UITableViewCell
        
        // configure cell
        self.configureCell(cell, atIndexPath: indexPath)
        
        // fetch from server... (loading table view after -refresh:)
        
        if self.datedRefreshed != nil {
            
            // get model object
            let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
            
            // get date cached
            let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
            
            // fetch if older than refresh date
            if dateCached == nil || dateCached?.compare(self.datedRefreshed!) == NSComparisonResult.OrderedDescending {
                
                Store.sharedStore.fetchEntity(managedObject.entity.name!, resourceID: managedObject.valueForKey(Store.sharedStore.resourceIDAttributeName) as UInt, completionBlock: { (error, managedObject) -> Void in
                    
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
    
    /** Subclasses should overrride this to provide custom cells. */
    private func dequeueReusableCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = NSStringFromClass(UITableViewCell)
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        return cell!
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withError error: NSError? = nil) {
        
        if error != nil {
            
            // TODO: Configure cell for error
            
        }
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(indexPath) as NSManagedObject
        
        let dateCached = managedObject.valueForKey(Store.sharedStore.dateCachedAttributeName!) as? NSDate
        
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
        
        // Entity name + resource ID
        cell.textLabel!.text = "\(managedObject.entity)" + "\(managedObject.valueForKey(Store.sharedStore.resourceIDAttributeName))"
    }
}
