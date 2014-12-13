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
    
    var selectedCurrencyLocale: NSLocale? {
        
        didSet {
            
            
        }
    }
    
    // MARK: - Private Properties
    
    private let localeIdentifiers = (NSLocale.availableLocaleIdentifiers() as NSArray).sortedArrayUsingSelector("localizedCaseInsensitiveCompare")
    
    private let locales: [NSLocale] = {
        
        let localeIdentifiers = NSLocale.availableLocaleIdentifiers() as [String]
        
        // create locales
        var locales = [NSLocale]()
        
        for localeID in localeIdentifiers {
            
            locales.append(NSLocale(localeIdentifier: localeID))
        }
        
        // sort by currency symbol
        let sortedLocales = (locales as NSArray).sortedArrayUsingComparator({ (first, second) -> NSComparisonResult in
            
            let firstCurrencyCode = (first as NSLocale).objectForKey(NSLocaleCurrencyCode) as String
            
            let secondCurrencyCode = (second as NSLocale).objectForKey(NSLocaleCurrencyCode) as String
            
            return (firstCurrencyCode as NSString).compare(secondCurrencyCode)
        }) as [NSLocale]
        
        return sortedLocales
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get all locales from system
        
        
    }
    
    
}