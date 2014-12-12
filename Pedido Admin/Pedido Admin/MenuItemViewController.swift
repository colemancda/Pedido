//
//  MenuItemViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/8/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CorePedido
import CorePedidoClient

class MenuItemViewController: UITableViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextfield: UITextField!
    
    @IBOutlet weak var currencySymbolLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: Model
    
    var menuItem: MenuItem? {
        
        didSet {
            
            if self.isViewLoaded() {
                
                self.updateUIForMenuItem(menuItem)
            }
        }
    }
    
    // MARK: - Attributes
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        self.updateUIForMenuItem(self.menuItem)
    }
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
        
        // attributes
        
        let name = self.nameTextField.text
        
        let price = self.numberFormatter.numberFromString(self.priceTextfield.text)
        
        // invalid price text
        if price == nil {
            
            self.showErrorAlert(NSLocalizedString("Invalid value for price.", comment: "Invalid value for price."))
            
            return
        }
        
        let newValues = ["name": name, "price": price!, "currencyLocale": self.currencyLocale]
        
        // create new menu item
        if self.menuItem == nil {
            
            Store.sharedStore.createEntity("MenuItem", withInitialValues: newValues, completionBlock: { (error, managedObject) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    // show error
                    if error != nil {
                        
                        self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                            
                            self.save(self)
                        })
                        
                        return
                    }
                    
                    self.performSegueWithIdentifier(MainStoryboardSegueIdentifier.SavedMenuItem.rawValue, sender: self)
                })
            })
            
            return
        }
        
        // update existing menu item
        
        Store.sharedStore.editManagedObject(self.menuItem!, changes: newValues, completionBlock: { (error) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, retryHandler: { () -> Void in
                        
                        self.save(self)
                    })
                    
                    return
                }
                
                self.performSegueWithIdentifier(MainStoryboardSegueIdentifier.SavedMenuItem.rawValue, sender: self)
            })
        })
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func updateUIForMenuItem(menuItem: MenuItem?) {
        
        if menuItem == nil {
            
            self.resetUI()
            
            return
        }
        
        // update UI
        
        self.nameTextField.text = menuItem!.name
        self.priceTextfield.text = "\(menuItem!.price)"
        self.currencyLocale = menuItem!.currencyLocale
    }
    
    private func resetUI() {
        
        self.nameTextField.text = ""
        self.priceTextfield.text = ""
        self.currencyLocale = NSLocale.currentLocale()
    }
}