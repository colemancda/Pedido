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

/// Contains code specific to our app's Main Storyboard. Makes our view controllers more reusable and less tied to this specific app.

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
    case EstablishmentMenuItemPicker = "establishmentMenuItemPicker"
    case EstablishmentImages = "establishmentImages"
    case EstablishmentEditLocation = "establishmentEditLocation"
    case EstablishmentOrders = "establishmentOrders"
    case SearchLocation = "searchLocation"
    case NewImage = "newImage"
}

enum MainStoryboardDetailControllerIdentifier: String {
    
    case EmptySelectionDetail = "EmptySelectionDetail"
    case MenuItemDetail = "MenuItemDetail"
    case EstablishmentDetail = "EstablishmentDetail"
    
}

// MARK: - Extensions

extension FetchedResultsViewController {
    
    func showMainStoryboardDetailController(detailController: MainStoryboardDetailControllerIdentifier, forManagedObjectAtIndexPath indexPath: NSIndexPath) {
        
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
                (managedObjectVC.tabBarController!.selectedViewController as UINavigationController).popToRootViewControllerAnimated(true)
                
                return
            }
        }
    }
}

extension ManagedObjectViewController {
    
    func handleManagedObjectDeletionForViewControllerInMainStoryboard() {
        
        // Detect if contained in splitViewController
        let regularLayout: Bool = (self.splitViewController?.viewControllers.count == 2) ?? false
        
        // Regular layout
        if regularLayout {
            
            // show empty selection if root VC and visible detail VC
            if self.navigationController!.viewControllers.first! as UIViewController == self &&
                self.splitViewController!.viewControllers[1] as UIViewController == self.navigationController! {
                
                // get detail navigation controller stack
                let detailNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier(MainStoryboardDetailControllerIdentifier.EmptySelectionDetail.rawValue) as UINavigationController
                
                // set detailVC
                self.splitViewController!.showDetailViewController(detailNavigationController, sender: self)
            }
        }
        
        // Compact layout
        else {
            
            // pop to root VC if top if second VC
            if self.navigationController!.viewControllers[1] as? UIViewController == self {
                
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
    }
}