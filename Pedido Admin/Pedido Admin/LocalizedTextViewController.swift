//
//  LocalizedTextViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/6/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido

class LocalizedTextViewController: ManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    var languageLocale: NSLocale! {
        
        didSet {
            
            self.languageLabel.text = (languageLocale.objectForKey(NSLocaleLanguageCode) as? NSString)!.uppercaseString
        }
    }
    
    // MARK: - Private Properties
    
    var viewSizeCache: CGSize!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load initial value
        self.languageLabel.text = (languageLocale.objectForKey(NSLocaleLanguageCode) as? NSString)!.uppercaseString
    }
    
    // MARK: - View Layout
    
    override func viewDidLayoutSubviews() {
        
        // check if view did resize
        if self.viewSizeCache != self.view.bounds.size {
            
            self.viewSizeCache = self.view.bounds.size
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    override func getNewValues() -> [String : AnyObject]? {
        
        // attributes
        
        let text = self.textView.text
        
        let languageLocaleIdentifier = self.languageLocale.localeIdentifier
        
        // invalid price text
        if text == "" {
            
            self.showErrorAlert(NSLocalizedString("Must enter text.", comment: "Must enter text."))
            
            return nil
        }
        
        return ["text": text, "locale": languageLocaleIdentifier]
    }
    
    override func configureUI(forManagedObject managedObject: NSManagedObject) {
        
        let localizedText = managedObject as LocalizedText
        
        // update UI
        self.languageLocale = NSLocale(localeIdentifier: localizedText.locale)
        self.textView.text = localizedText.text
    }
    
    override func resetUI() {
        
        self.languageLocale = NSLocale(localeIdentifier: NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as String)
        self.textView.text = ""
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .LocalizedDescriptionPickLanguageLocale:
            
            let languageLocalePickerVC = segue.destinationViewController as LanguageLocalePickerViewController
            
            languageLocalePickerVC.selectedLanguageLocale = self.languageLocale
            
            // set handler
            languageLocalePickerVC.selectionHandler = {
                
                self.languageLocale = languageLocalePickerVC.selectedLanguageLocale!
            }
            
        default:
            return
        }
    }
}