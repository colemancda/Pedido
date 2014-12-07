//
//  Store.swift
//  CorePedidoClient
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

public class Store: NetworkObjects.Store {
    
    // MARK: - Properties
    
    var delegate: StoreDelegate?
    
    // MARK: - Initialization
    
    init(persistentStoreCoordinator: NSPersistentStoreCoordinator,
        managedObjectContextConcurrencyType: NSManagedObjectContextConcurrencyType,
        serverURL: NSURL,
        prettyPrintJSON: Bool,
        delegate: StoreDelegate?) {
            
            self.delegate = delegate
            
            super.init(persistentStoreCoordinator: persistentStoreCoordinator,
                managedObjectContextConcurrencyType: managedObjectContextConcurrencyType,
                serverURL: serverURL,
                prettyPrintJSON: prettyPrintJSON,
                resourceIDAttributeName: "id",
                dateCachedAttributeName: "dateCached",
                searchPath: "search")
    }
    
    // MARK: - Methods
    
    public func loginWithUsername(username: String, password: String, URLSession: NSURLSession = NSURLSession.sharedSession(), completionBlock: (error: NSError?, token: String?) -> Void) -> NSURLSessionDataTask {
        
        let loginURL = self.serverURL.URLByAppendingPathComponent("login")
        
        let request = NSMutableURLRequest(URL: loginURL)
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(["username": username, "password": password], options: NSJSONWritingOptions.allZeros, error: nil)
        
        return URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            
        })
    }
}

// MARK: - Protocols

public protocol StoreDelegate {
    
    /** Notifies the delegate that the Store successfully authenticated with the specified credentials. The delegate should store the token for future use. */
    func store(store: Store, didLoginWithUsername username: String, password: String, token: String)
    
    /** Asks the delegate for a stored token. Called before each authenticated request. */
    func tokenForStore(store: Store)  -> String?
}


