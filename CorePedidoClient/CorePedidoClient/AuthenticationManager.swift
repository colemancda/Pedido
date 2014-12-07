//
//  AuthenticationManager.swift
//  CorePedidoClient
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation

public class AuthenticationManager: StoreDelegate {
    
    // MARK: - Properties
    
    /** The store this manager will manage tokens for. Ensures that tokens can only be requested and provided by one object. */
    public let store: Store
    
    // MARK: - Private Properties
    
    private let accessOperationQueue: NSOperationQueue = {
        
        let operationQueue = NSOperationQueue()
        
        operationQueue.name = "AuthenticationManager Private Variables Access Operation Queue"
        
        operationQueue.maxConcurrentOperationCount = 1
        
        return operationQueue
    }()
    
    private var token: String?
    
    private var username: String?
    
    private var password: String?
    
    // MARK: - Initialization
    
    public init(store: Store) {
        
        self.store = store
    }
    
    // MARK: - StoreDelegate
    
    public func tokenForStore(store: Store) -> String? {
        
        assert(store === self.store, "Only the manager's store can call the delegate methods")
        
        var token: String?
        
        self.accessOperationQueue.addOperations([NSBlockOperation(block: { () -> Void in
            
            token = self.token
            
        })], waitUntilFinished: true)
        
        return token
    }
    
    public func store(store: Store, didLoginWithUsername username: String, password: String, token: String) {
        
        assert(store === self.store, "Only the manager's store can call the delegate methods")
        
        self.accessOperationQueue.addOperationWithBlock { () -> Void in
            
            self.token = token
            
            self.username = username
            
            self.password = password
        }
    }
}


