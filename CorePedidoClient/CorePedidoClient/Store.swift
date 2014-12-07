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
    
    public var delegate: StoreDelegate?
    
    public let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: CorePedidoManagedObjectModel)
    
    // MARK: - Initialization
    
    public init(managedObjectContextConcurrencyType: NSManagedObjectContextConcurrencyType,
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
    
    // MARK: - Requests
    
    public func loginWithUsername(username: String, password: String, URLSession: NSURLSession = NSURLSession.sharedSession(), completionBlock: (error: NSError?, token: String?) -> Void) -> NSURLSessionDataTask {
        
        let loginURL = self.serverURL.URLByAppendingPathComponent("login")
        
        let request = NSMutableURLRequest(URL: loginURL)
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(["username": username, "password": password], options: NSJSONWritingOptions.allZeros, error: nil)
        
        let dataTask = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if error != nil {
                
                completionBlock(error: error, token: nil)
            }
            
            let httpResponse = response as NSHTTPURLResponse
            
            // error codes
            
            if httpResponse.statusCode != ServerStatusCode.OK.rawValue {
                
                let errorCode = ErrorCode(rawValue: httpResponse.statusCode)
                
                if errorCode != nil {
                    
                    if errorCode == ErrorCode.ServerStatusCodeForbidden {
                        
                        let frameworkBundle = NSBundle(identifier: "com.colemancda.CorePedidoClient")
                        let tableName = "Error"
                        let comment = "Description for ErrorCode.\(errorCode!.rawValue) for Login Request"
                        let key = "ErrorCode.\(errorCode!.rawValue).LocalizedDescription.Login"
                        let value = "Username or password is incorrect"
                        
                        let customError = NSError(domain: CorePedidoClientErrorDomain, code: errorCode!.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(key, tableName: tableName, bundle: frameworkBundle!, value: value, comment: comment)])
                        
                        completionBlock(error: customError, token: nil)
                        
                        return
                    }
                    
                    completionBlock(error: errorCode!.toError(), token: nil)
                    
                    return
                }
                
                // no recognizeable error code
                completionBlock(error: ErrorCode.InvalidServerResponse.toError(), token: nil)
                
                return
            }
            
            // parse response...
            
            let jsonObject = NSJSONSerialization.JSONObjectWithData(request.HTTPBody!, options: NSJSONReadingOptions.allZeros, error: nil) as? [String: String]
            
            let token = jsonObject?["token"]
            
            // invalid JSON response
            if token == nil {
                
                completionBlock(error: ErrorCode.InvalidServerResponse.toError(), token: nil)
                
                return
            }
            
            // tell delegate
            self.delegate?.store(self, didLoginWithUsername: username, password: password, token: token!)
            
            // completion block
            completionBlock(error: nil, token: token)
        })
        
        dataTask.resume()
        
        return dataTask
    }
    
    // MARK: - Build URL Requests
    
    public override func requestForSearchEntity(name: String, withParameters parameters: [String : AnyObject]) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: super.requestForSearchEntity(name, withParameters: parameters))
    }
    
    public override func requestForCreateEntity(name: String, withInitialValues initialValues: [String : AnyObject]?) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: super.requestForCreateEntity(name, withInitialValues: initialValues))
    }
    
    public override func requestForFetchEntity(name: String, resourceID: UInt) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: super.requestForFetchEntity(name, resourceID: resourceID))
    }
    
    public override func requestForEditEntity(name: String, resourceID: UInt, changes: [String : AnyObject]) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: super.requestForEditEntity(name, resourceID: resourceID, changes: changes))
    }
    
    public override func requestForDeleteEntity(name: String, resourceID: UInt) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: super.requestForDeleteEntity(name, resourceID: resourceID))
    }
    
    public override func requestForPerformFunction(functionName: String, entityName: String, resourceID: UInt, JSONObject: [String : AnyObject]?) -> NSURLRequest {
        
        return self.appendAuthorizationHeaderToRequest(request: self.requestForPerformFunction(functionName, entityName: entityName, resourceID: resourceID, JSONObject: JSONObject))
    }
    
    // MARK: - Private Methods
    
    private func appendAuthorizationHeaderToRequest(request originalRequest: NSURLRequest) -> NSURLRequest {
        
        let token = self.delegate?.tokenForStore(self)
        
        if token == nil {
            
            return originalRequest
        }
        
        let request = originalRequest.mutableCopy() as NSMutableURLRequest
        
        request.setValue(token, forHTTPHeaderField: AuthorizationHeader)
        
        return request
    }
}

// MARK: - Protocols

public protocol StoreDelegate {
    
    /** Notifies the delegate that the Store successfully authenticated with the specified credentials. The delegate should store the token for future use. */
    func store(store: Store, didLoginWithUsername username: String, password: String, token: String)
    
    /** Asks the delegate for a stored token. Called before each authenticated request. */
    func tokenForStore(store: Store)  -> String?
}

// MARK: - Private Constants

private let AuthorizationHeader = "Authorization"


