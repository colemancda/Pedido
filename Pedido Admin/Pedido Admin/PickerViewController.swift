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
    
    var configuration: PickerViewControllerConfiguration? {
        
        didSet {
            
            if configuration == nil {
                
                return
            }
            
            if self.isViewLoaded() {
                
                self.configureViewControllerWithConfiguration(configuration!)
            }
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.configuration != nil {
            
            self.configureViewControllerWithConfiguration(self.configuration!)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // try to update relationship on server
        
    }
    
    // MARK: - Private Methods
    
    private func configureViewControllerWithConfiguration(configuration: PickerViewControllerConfiguration) {
        
        self.tableView.allowsMultipleSelection = configuration.isToMany
        
        // create fetch request
        let fetchRequest =
    }
}


class PickerViewControllerConfiguration {
    
    let inverseRelationshipName: String
    
    let inverseRelationshipValue: NSManagedObject
    
    let isToMany: Bool
    
    init(inverseRelationshipName: String, inverseRelationshipValue: NSManagedObject, isToMany: Bool = false) {
        
        self.inverseRelationshipName = inverseRelationshipName
        self.inverseRelationshipValue = inverseRelationshipValue
        self.isToMany = isToMany
    }
}