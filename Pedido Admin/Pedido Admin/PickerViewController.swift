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

class PickerViewController: UITableViewController {
    
    // MARK: - Properties
    
    var entityName: String?
    
    var selectedItems: [NSManagedObject]?
    
    var allowsMultipleSelection: Bool {
        
        set {
            self.tableView.allowsMultipleSelection = allowsMultipleSelection
        }
        
        get {
            return self.tableView.allowsMultipleSelection
        }
    }
    
    /** The key that will be displayed. */
    var displayedAttributeName: String?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}