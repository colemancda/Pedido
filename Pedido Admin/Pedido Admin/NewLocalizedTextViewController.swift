//
//  NewLocalizedTextViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/6/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewLocalizedTextViewController: NewManagedObjectViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    override var entityName: String {
        
        return "LocalizedText"
    }
    
    var parentManagedObject: (NSManagedObject, String)!
    
    var languageLocale: NSLocale! = NSLocale(localeIdentifier: NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String)
        {
        
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
        
        // cache view size
        self.viewSizeCache = self.view.bounds.size
        
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
        
        // relationship
        let (managedObject, parentManagedObjectKey) = self.parentManagedObject
        
        return ["text": text, "locale": languageLocaleIdentifier, parentManagedObjectKey: managedObject]
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // override row height
        
        switch indexPath.row {
            
        case 1:
            // view height - (1st cell hieght + grouped cell padding)
            return self.view.bounds.size.height - 180
            
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .NewLocalizedDescriptionPickLanguageLocale:
            
            let languageLocalePickerVC = segue.destinationViewController as! LanguageLocalePickerViewController
            
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