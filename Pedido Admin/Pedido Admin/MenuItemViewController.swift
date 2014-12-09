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
    
    var menuItem: MenuItem? {
        
        didSet {
            
            self.updateUIForMenuItem(menuItem)
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set UI to initial values
        self.resetUI()
    }
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.currencySymbolLabel.text = menuItem!.currencyLocale.objectForKey(NSLocaleCurrencySymbol) as? String
    }
    
    private func resetUI() {
        
        self.nameTextField.text = ""
        self.priceTextfield.text = ""
        self.currencySymbolLabel.text = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as? String
    }
}