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
    
    /** Language locales sorted by ISO code. */
    class var languageLocales: [NSLocale] {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : [NSLocale]? = nil
        }
        dispatch_once(&Static.onceToken) {
            
            let languageLocales: [NSLocale] = {
                
                let languageCodes = (NSLocale.ISOLanguageCodes() as NSArray).sortedArrayUsingSelector("localizedCaseInsensitiveCompare:") as [String]
                
                // create locales
                var locales = [NSLocale]()
                
                for languageCode in languageCodes {
                    
                    let locale = NSLocale(localeIdentifier: languageCode)
                    
                    locales.append(locale)
                }
                
                return locales
            }()
            
            Static.instance = languageLocales
        }
        return Static.instance!
    }
    
    /** The selected language locale. */
    var selectedLanguageLocale: NSLocale? {
        
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
    
    private var filteredLanguageLocales: [NSLocale]?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all locales
        self.filteredLanguageLocales = self.dynamicType.languageLocales
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredLanguageLocales?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.LanguageLocaleCell.rawValue, forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get model
        let locale = self.filteredLanguageLocales![indexPath.row]
        
        // set selected
        self.selectedLanguageLocale = locale
        
        // perform selected handler
        self.selectionHandler?()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSOperationQueue().addOperationWithBlock { () -> Void in
            
            if searchText == "" {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    // load all locales
                    self.filteredLanguageLocales = self.dynamicType.languageLocales
                    
                    // reload table view
                    self.tableView.reloadData()
                })
                
                return
            }
            
            // filter locales
            let newFilteredLanguageLocales: [NSLocale] = {
                
                let predicate = NSPredicate(format: "localeIdentifier contains[c] %@", searchText)
                
                let filteredResults = (self.dynamicType.languageLocales as NSArray).filteredArrayUsingPredicate(predicate!) as [NSLocale]
                
                return filteredResults
                }()
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.filteredLanguageLocales = newFilteredLanguageLocales
                
                // reload table view
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Private Methods
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get model
        let locale = self.filteredLanguageLocales![indexPath.row]
        
        // configure cell
        cell.textLabel!.text = (locale.objectForKey(NSLocaleLanguageCode) as NSString).uppercaseString
        
        // add checkmark if selected
        if locale == self.selectedLanguageLocale {
            
            cell.accessoryType = .Checkmark
        }
        else {
            
            cell.accessoryType = .None
        }
    }
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case LanguageLocaleCell = "LanguageLocaleCell"
}
