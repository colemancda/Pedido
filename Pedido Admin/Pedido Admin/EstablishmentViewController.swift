//
//  EstablishmentViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/1/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido

class EstablishmentViewController: ManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    
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
    
    override func configureUI(forManagedObject managedObject: NSManagedObject) {
        
        let establishment = managedObject as Establishment
        
        self.locationTextField.text = establishment.location
    }
    
    override func resetUI() {
        
        self.locationTextField.text = ""
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .EstablishmentMenuItemPicker:
            
            let pickerVC = segue.destinationViewController as PickerViewController
            
            pickerVC.relationship = (self.managedObject!, "menuItems")
            
        case .EstablishmentImages:
            
            let relationshipVC = segue.destinationViewController as RelationshipViewController
            
            relationshipVC.relationship = (self.managedObject!, "images")
            
        default:
            return
        }
    }
}