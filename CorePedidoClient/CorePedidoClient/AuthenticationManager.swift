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
    
    /** The store this manager will provide tokens to. Ensures that tokens can only be requested by one object. */
    public let store: Store
    
    // MARK: - Private Properties
    
    private let tokenOperationQueue: NSOperationQueue = {
        
        let operationQueue = NSOperationQueue()
        
        operationQueue.name = "AuthenticationManager Token Operation Queue"
        
        operationQueue.maxConcurrentOperationCount = 1
        
        return operationQueue
    }()
    
    private var token: String?
    
    // MARK: - Initialization
    
    public init(store: Store) {
        
        self.store = store
    }
    
    // MARK: - StoreDelegate
    
    public func tokenForStore(store: Store) -> String? {
        
        assert(store === self.store, "Only the manager's store can call the delegate methods")
        
        var token: String?
        
        self.tokenOperationQueue.addOperations([NSBlockOperation(block: { () -> Void in
            
            token = self.token
            
        })], waitUntilFinished: true)
        
        return token
    }
    
    public func store(store: Store, didLoginWithUsername username: String, password: String, token: String) {
        
        assert(store === self.store, "Only the manager's store can call the delegate methods")
        
        self.tokenOperationQueue.addOperationWithBlock { () -> Void in
            
            self.token = token
        }
    }
}


