//
//  AuthenticationManager.swift
//  CorePedidoClient
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation

public class AuthenticationManager: StoreDelegate {
    
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
    
    public init() {
        
        
    }
    
    // MARK: - StoreDelegate
    
    public func tokenForStore(store: Store) -> String? {
        
        var token: String?
        
        self.accessOperationQueue.addOperations([NSBlockOperation(block: { () -> Void in
            
            token = self.token
            
        })], waitUntilFinished: true)
        
        return token
    }
    
    public func store(store: Store, didLoginWithUsername username: String, password: String, token: String) {
                
        self.accessOperationQueue.addOperationWithBlock { () -> Void in
            
            self.token = token
            
            self.username = username
            
            self.password = password
        }
    }
}


