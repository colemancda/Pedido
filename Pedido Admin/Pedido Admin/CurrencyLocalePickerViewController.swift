//
//  CurrencyLocalePickerViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/12/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

class CurrencyLocalePickerViewController: UITableViewController {
    
    // MARK: - Properties
    
    /** Currency Locales sorted by ISO code. */
    class var currencyLocales: [NSLocale] {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : [NSLocale]? = nil
        }
        dispatch_once(&Static.onceToken) {
            
            let currencylocales: [NSLocale] = {
                
                let localeIdentifiers = NSLocale.availableLocaleIdentifiers() as [String]
                
                // create locales
                var locales = [NSLocale]()
                
                for localeID in localeIdentifiers {
                    
                    let locale = NSLocale(localeIdentifier: localeID)
                    
                    if let currencyCode = locale.objectForKey(NSLocaleCurrencyCode) as? String {
                        
                        locales.append(NSLocale(localeIdentifier: localeID))
                    }
                }
                
                // sort by currency symbol
                let sortedLocales = (locales as NSArray).sortedArrayUsingComparator({ (first, second) -> NSComparisonResult in
                    
                    let firstCurrencyCode = (first as NSLocale).objectForKey(NSLocaleCurrencyCode) as String
                    
                    let secondCurrencyCode = (second as NSLocale).objectForKey(NSLocaleCurrencyCode) as String
                    
                    return (firstCurrencyCode as NSString).compare(secondCurrencyCode)
                }) as [NSLocale]
                
                return sortedLocales
                }()
            
            Static.instance = currencylocales
        }
        return Static.instance!
    }
    
    /** The selected currency locale. */
    var selectedCurrencyLocale: NSLocale? {
        
        didSet {
            
            
        }
    }
    
    // MARK: - Private Properties
    
    private let numberFormatter: NSNumberFormatter = {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = .CurrencyStyle
        
        return numberFormatter
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get all locales from system
        
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dynamicType.currencyLocales.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CurrencyLocaleCell.rawValue, forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - Private Methods
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get model
        
        let locale = self.dynamicType.currencyLocales[indexPath.row]
        
        
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case CurrencyLocaleCell = "CurrencyLocaleCell"
}

