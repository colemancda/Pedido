//
//  LanguageLocalePickerViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/6/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

class LanguageLocalePickerViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    /** Currency Locales sorted by ISO code. */
    class var languageLocales: [NSLocale] {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : [NSLocale]? = nil
        }
        dispatch_once(&Static.onceToken) {
            
            let languageLocales: [NSLocale] = {
                
                let languageCodes = NSLocale.ISOLanguageCodes() as [String]
                
                // create locales
                var locales = [NSLocale]()
                
                for languageCode in languageCodes {
                    
                    let locale = NSLocale(localeIdentifier: languageCode)
                    
                    locales.append(locale)
                }
                
                // sort by currency symbol
                let sortedLocales = (locales as NSArray).sortedArrayUsingComparator({ (first, second) -> NSComparisonResult in
                    
                    let firstLocale = first as NSLocale
                    
                    let secondLocale = second as NSLocale
                    
                    return (firstLocale.localeIdentifier as NSString).compare(secondLocale.localeIdentifier)
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
            
            // reload table view
            if self.isViewLoaded() {
                
                self.tableView.reloadData()
            }
        }
    }
    
    /** Block executed when a selection is made. */
    var selectionHandler: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var filteredCurrencyLocales: [NSLocale]?
    
    private let numberFormatter: NSNumberFormatter = {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = .CurrencyStyle
        
        return numberFormatter
        }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all locales
        self.filteredCurrencyLocales = self.dynamicType.currencyLocales
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredCurrencyLocales?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CurrencyLocaleCell.rawValue, forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get model
        let locale = self.filteredCurrencyLocales![indexPath.row]
        
        // set selected
        self.selectedCurrencyLocale = locale
        
        // perform selected handler
        self.selectionHandler?()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSOperationQueue().addOperationWithBlock { () -> Void in
            
            // filter locales
            let newFilteredCurrencyLocales: [NSLocale] = {
                
                let predicate = NSPredicate(format: "localeIdentifier contains[c] %@", searchText)
                
                let filteredResults = (self.dynamicType.currencyLocales as NSArray).filteredArrayUsingPredicate(predicate!) as [NSLocale]
                
                return filteredResults
                }()
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.filteredCurrencyLocales = newFilteredCurrencyLocales
                
                // reload table view
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Private Methods
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get model
        let locale = self.filteredCurrencyLocales![indexPath.row]
        
        // configure cell
        cell.textLabel!.text = locale.localeIdentifier
        cell.detailTextLabel!.text = locale.objectForKey(NSLocaleCurrencySymbol) as? String
        
        // add checkmark if selected
        if locale == self.selectedCurrencyLocale {
            
            cell.accessoryType = .Checkmark
        }
        else {
            
            cell.accessoryType = .None
        }
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case CurrencyLocaleCell = "CurrencyLocaleCell"
}
