//
//  AppDelegate.swift
//  Pedido
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import NetworkObjects
import CorePedido
import CorePedidoClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - Extensions

extension CorePedidoClient.Store {
    
    class var sharedStore : CorePedidoClient.Store {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CorePedidoClient.Store? = nil
        }
        dispatch_once(&Static.onceToken) {
            
            let psc = NSPersistentStoreCoordinator(managedObjectModel: CorePedidoManagedObjectModel())
            
            // add persistent store
            
            var error: NSError?
            
            psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &error)
            
            assert(error == nil, "Could add persistent store. (\(error!.localizedDescription))")
            
            let serverURL = NSURL(string: "http://localhost")!
            
            let store = CorePedidoClient.Store(persistentStoreCoordinator: psc,
                managedObjectContextConcurrencyType: .MainQueueConcurrencyType,
                serverURL: serverURL,
                prettyPrintJSON: true,
                delegate: AuthenticationManager.sharedManager)
            
            Static.instance = store
        }
        return Static.instance!
    }
}

extension AuthenticationManager {
    
    class var sharedManager : AuthenticationManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AuthenticationManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AuthenticationManager(store: Store.sharedStore)
        }
        return Static.instance!
    }
}