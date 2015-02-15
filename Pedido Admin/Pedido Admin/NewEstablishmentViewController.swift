//
//  NewEstablishmentViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/1/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

class NewEstablishmentViewController: NewManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    
    // MARK: - Properties
    
    override var entityName: String {
        
        return "Establishment"
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // MARK: - Methods
    
    override func getNewValues() -> [String : AnyObject]? {
        
        let location = self.locationTextField.text
        
        if location == "" {
            
            self.showErrorAlert(NSLocalizedString("Enter a location for the establishment.", comment: "Enter a location for the establishment."))
            
            return nil
        }
        
        return ["location": location]
    }
}