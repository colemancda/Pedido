//
//  MenuItemViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/8/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

class MenuItemViewController: ManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextfield: UITextField!
    
    @IBOutlet weak var currencySymbolLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: Attributes
    
    var currencyLocale: NSLocale = NSLocale.currentLocale() {
        
        didSet {
            
            // update UI
            self.currencySymbolLabel.text = currencyLocale.objectForKey(NSLocaleCurrencySymbol) as? String
            
            // set locale on number formatter
            self.numberFormatter.locale = self.currencyLocale
        }
    }
    
    // MARK: Relationships
    
    
    
    // MARK: - Private Properties
    
    lazy var numberFormatter: NSNumberFormatter = {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        numberFormatter.locale = self.currencyLocale
        
        numberFormatter.currencySymbol = ""
        
        return numberFormatter
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.entityName = "MenuItem"
    }
    
    // MARK: - Methods
    
    override func getNewValues() -> [String : AnyObject]? {
        
        // attributes
        
        let name = self.nameTextField.text
        
        let price = self.numberFormatter.numberFromString(self.priceTextfield.text)
        
        // invalid price text
        if price == nil {
            
            self.showErrorAlert(NSLocalizedString("Invalid value for price.", comment: "Invalid value for price."))
            
            return nil
        }
        
        return ["name": name, "price": price!, "currencyLocale": self.currencyLocale]
    }
    
    override func configureUI(forManagedObject managedObject: NSManagedObject) {
        
        let menuItem = managedObject as MenuItem
        
        // update UI
        
        self.nameTextField.text = menuItem.name
        self.priceTextfield.text = self.numberFormatter.stringFromNumber(menuItem.price)
        self.currencyLocale = menuItem.currencyLocale
    }
    
    override func resetUI() {
        
        self.nameTextField.text = ""
        self.priceTextfield.text = ""
        self.currencyLocale = NSLocale.currentLocale()
    }
}