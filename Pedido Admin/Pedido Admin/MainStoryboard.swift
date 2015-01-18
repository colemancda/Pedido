//
//  MainStoryboard.swift
//  PedidoAdmin
//
//  Created by Alsey Coleman Miller on 1/18/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Enumerations

enum MainStoryboardSegueIdentifier: String {
    
    case Authentication = "authentication"
    case NewMenuItem = "newMenuItem"
    case MenuItemPickCurrencyLocale = "menuItemPickCurrencyLocale"
    case NewMenuItemPickCurrencyLocale = "newMenuItemPickCurrencyLocale"
    case MenuItemEstablishmentPicker = "menuItemEstablishmentPicker"
    case MenuItemLocalizedDescriptions = "menuItemLocalizedDescriptions"
    case MenuItemImages = "menuItemImages"
    case ShowLocalizedDescription = "showLocalizedDescription"
    case NewLocalizedDescription = "newLocalizedDescription"
    case LocalizedDescriptionPickLanguageLocale = "localizedDescriptionPickLanguageLocale"
    case NewLocalizedDescriptionPickLanguageLocale = "newLocalizedDescriptionPickLanguageLocale"
    case NewEstablishment = "newEstablishment"
    case EstablishmentEditLocation = "establishmentEditLocation"
    case SearchLocation = "searchLocation"
    case EstablishmentMenuItemPicker = "establishmentMenuItemPicker"
    case EstablishmentImages = "establishmentImages"
    case NewImage = "newImage"
}

enum MainStoryboardDetailControllerIdentifier: String {
    
    case MenuItemDetail = "MenuItemDetail"
    case EstablishmentDetail = "EstablishmentDetail"
    case EmptySelectionDetail = "EmptySelectionDetail"
}

// MARK: - Extensions

extension FetchedResultsViewController {
    
    func showDetailController(detailController: MainStoryboardDetailControllerIdentifier, forManagedObjectAtIndexPath indexPath: NSIndexPath) {
        
        // get model object
        let managedObject = self.fetchedResultsController!.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as NSManagedObject
        
        // get detail navigation controller stack
        let detailNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier(detailController.rawValue) as UINavigationController
        
        // get managed object VC
        let managedObjectVC = detailNavigationController.topViewController as ManagedObjectViewController
        
        // set model object
        managedObjectVC.managedObject = managedObject
        
        // show navigation stack based on splitVC setup
        if self.splitViewController!.viewControllers.count == 2 {
            
            // set detailVC
            self.splitViewController!.showDetailViewController(detailNavigationController, sender: self)
            
            // no edit handler
        }
        else {
            
            // set detailVC
            self.showViewController(detailNavigationController, sender: self)
            
            // set edit handler
            managedObjectVC.didEditManagedObjectHandler = {
                
                // pop VC
                managedObjectVC.navigationController!.popViewControllerAnimated(true)
                
                return
            }
        }
    }
}