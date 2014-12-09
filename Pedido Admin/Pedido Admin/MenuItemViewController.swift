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
    
    var currencyLocale: NSLocale {
        
        didSet {
            
            // update UI
            
            self.currencyNumberFormatter.locale = self.currencyLocale
            
            self.currencySymbolLabel.text = self.currencyNumberFormatter.currencySymbol
        }
    }
    
    // MARK: - Private Properties
    
    private let currencyNumberFormatter: NSNumberFormatter = {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        return numberFormatter
        }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set defualt locale
        self.currencyLocale = NSLocale.currentLocale()
    }
    
    // MARK: - Private Methods
    
    private func updateUIForMenuItem(menuItem: MenuItem?) {
        
        if menuItem == nil {
            
            self.resetUI()
            
            return
        }
        
        // update UI
        
        
    }
    
    private func resetUI() {
        
        
    }
}