//
//  NewMenuItemViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/27/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

class NewMenuItemViewController: NewManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextfield: UITextField!
    
    @IBOutlet weak var currencySymbolLabel: UILabel!
    
    // MARK: - Properties
    
    override var entityName: String {
        
        return "MenuItem"
    }
    
    var currencyLocale: NSLocale = NSLocale.currentLocale() {
        
        didSet {
            
            // update UI
            self.currencySymbolLabel.text = currencyLocale.objectForKey(NSLocaleCurrencySymbol) as? String
            
            // set locale on number formatter
            self.numberFormatter.locale = self.currencyLocale
        }
    }
    
    // MARK: - Private Properties
    
    lazy var numberFormatter: NSNumberFormatter = {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        numberFormatter.locale = self.currencyLocale
        
        numberFormatter.currencySymbol = ""
        
        return numberFormatter
        }()
    
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
        
        return ["name": name, "price": price!, "currencyLocaleIdentifier": self.currencyLocale.localeIdentifier]
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .NewMenuItemPickCurrencyLocale:
            
            let currencyLocalePickerVC = segue.destinationViewController as CurrencyLocalePickerViewController
            
            currencyLocalePickerVC.selectedCurrencyLocale = self.currencyLocale
            
            // set handler
            currencyLocalePickerVC.selectionHandler = {
                
                self.currencyLocale = currencyLocalePickerVC.selectedCurrencyLocale!
            }
            
        default:
            return
        }
    }
    
}