//
//  ServerManager.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/5/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

@objc public class ServerManager: ServerDataSource, ServerDelegate {
    
    // MARK: - Properties
    
    public lazy var server: Server = {
        
         return Server(dataSource: self, delegate: self, managedObjectModel: self.model, searchPath: "search", resourceIDAttributeName: "id", sslIdentityAndCertificates: nil, permissionsEnabled: true)
    }()
    
    public let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    // MARK: - Private Properties
    
    private let model = NSManagedObjectModel(contentsOfURL: NSBundle(identifier: "com.colemancda.CorePedido")!.URLForResource("Model", withExtension: "momd")!)!
    
    private var latestResourceIDForEntity = [NSEntityDescription: UInt]()
    
    // MARK: - Initialization
    
    public class var sharedManager : ServerManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ServerManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ServerManager()
        }
        return Static.instance!
    }
    
    public init() {
        
        // setup persistent store
        self.managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        let error = NSErrorPointer()
        
        self.managedObjectContext.persistentStoreCoordinator?.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: error)!
    }
    
    // MARK: - Actions
    
    /** Starts broadcasting the server. */
    public func start(onPort port: UInt) -> NSError? {
        
        return self.server.start(onPort: port);
    }
    
    /** Stops broadcasting the server. */
    public func stop() {
        
        self.server.stop();
    }
    
    // MARK: - ServerDataSource
    
    public func server(server: Server, resourcePathForEntity entity: NSEntityDescription) -> String {
        
        return entity.name!
    }
    
    public func server(server: Server, managedObjectContextForRequest request: ServerRequest) -> NSManagedObjectContext {
        
        return managedObjectContext;
    }
    
    public func server(server: Server, newResourceIDForEntity entity: NSEntityDescription) -> UInt {
        
        // get last resource ID
        let lastResourceID = self.latestResourceIDForEntity[entity]
        
        // create new one
        var newResourceID: UInt = 0
        
        // if not first resource ID, increment by 1
        if lastResourceID != nil {
            
            newResourceID = lastResourceID! + 1;
        }
        
        // save new one
        self.latestResourceIDForEntity[entity] = newResourceID;
        
        return newResourceID
    }
    
    public func server(server: Server, functionsForEntity entity: NSEntityDescription) -> [String] {
        
        return FunctionsForEntity(entity)
    }
    
    public func server(server: Server, performFunction functionName: String, forManagedObject managedObject: NSManagedObject, context: NSManagedObjectContext, recievedJsonObject: [String : AnyObject]?) -> (ServerFunctionCode, [String : AnyObject]?) {
        
        // get user
        
        return PerformFunction(functionName, managedObject, context, user, recievedJsonObject)
    }
    
    // MARK: - ServerDelegate
    
    public func server(server: Server, didEncounterInternalError error: NSError, forRequest request: ServerRequest, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Internal error occurred for request: \(request), userInfo: \(userInfo). (\(error))")
    }
    
    public func server(server: Server, didPerformRequest request: ServerRequest, withResponse response: ServerResponse, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Successfully performed request and responded with: (\(response.statusCode.rawValue)) \(response.JSONResponse)")
    }
    
    public func server(server: Server, statusCodeForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext) -> ServerStatusCode {
        
        return ServerStatusCode.OK
    }
    
    public func server(server: Server, permissionForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext, key: String?) -> ServerPermission {
        
        if managedObject == nil {
            
            return ServerPermission.EditPermission
        }
        
        // get authenticated user from request and return permssions based on authenticated user
        
        var user: User?
        
        context.performBlockAndWait { () -> Void in
            
            // create request
            let fetchRequest = NSFetchRequest(entityName: "User")
            
            
            
        }
                
        return permissionForRequest(request, user, managedObject, key, context)
    }
}

// MARK: - Private Constants

private let ServerApplicationSupportFolderURL = NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.LocalDomainMask, appropriateForURL: nil, create: false, error: nil)?.URLByAppendingPathComponent("PedidoServer")
