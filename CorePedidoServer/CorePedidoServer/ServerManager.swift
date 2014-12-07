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
import RoutingHTTPServer
import CorePedido

@objc public class ServerManager: ServerDataSource, ServerDelegate {
    
    // MARK: - Properties
    
    public lazy var server: Server = {
        
        // create server
        let server = Server(dataSource: self, delegate: self, managedObjectModel: self.model, searchPath: "search", resourceIDAttributeName: "id", sslIdentityAndCertificates: nil, permissionsEnabled: true)
        
        self.addAuthenticationHandlerToServer(server)
        
        return server
    }()
    
    public let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    public let sessionTokenLength: UInt = 25
    
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
    
    public func server(server: Server, performFunction functionName: String, forManagedObject managedObject: NSManagedObject, context: NSManagedObjectContext, recievedJsonObject: [String : AnyObject]?, request: ServerRequest) -> (ServerFunctionCode, [String : AnyObject]?) {
        
        // get user
        let (session, error) = AuthenticationSessionFromRequestHeaders(request.headers, context)
        
        // report internal error
        if error != nil {
            
            println("Internal error occurred while trying to get session from authentication headers. (\(error?.localizedDescription))")
        }
        
        return PerformFunction(functionName, managedObject, context, session, recievedJsonObject)
    }
    
    // MARK: - ServerDelegate
    
    public func server(server: Server, didEncounterInternalError error: NSError, forRequest request: ServerRequest, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Internal error occurred for request: \(request), userInfo: \(userInfo). (\(error))")
    }
    
    public func server(server: Server, didPerformRequest request: ServerRequest, withResponse response: ServerResponse, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Successfully performed request and responded with: (\(response.statusCode.rawValue)) \(response.JSONResponse)")
    }
    
    public func server(server: Server, didInsertManagedObject: NSManagedObject, context: NSManagedObjectContext) {
        
        //
    }
    
    public func server(server: Server, statusCodeForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext) -> ServerStatusCode {
        
        return ServerStatusCode.OK
    }
    
    public func server(server: Server, permissionForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext, key: String?) -> ServerPermission {
        
        if managedObject == nil {
            
            return ServerPermission.EditPermission
        }
        
        // get authenticated user from request and return permssions based on authenticated user
        
        let (session, error) = AuthenticationSessionFromRequestHeaders(request.headers, context)
        
        // report internal error
        if error != nil {
            
            println("Internal error occurred while trying to get session from authentication headers. (\(error?.localizedDescription))")
        }
        
        // get permissions
        return PermissionForRequest(request, session, managedObject, key, context)
    }
    
    // MARK: - Private Methods
    
    private func addAuthenticationHandlerToServer(server: Server) {
        
        server.httpServer.post("/login", withBlock: { (request: RouteRequest!, response: RouteResponse!) -> Void in
            
            // get values...
            
            let jsonObject = NSJSONSerialization.JSONObjectWithData(request.body(), options: NSJSONReadingOptions.allZeros, error: nil) as? [String: String]
            
            let username = jsonObject?["username"]
            
            let password = jsonObject?["password"]
            
            if username == nil || password == nil {
                
                response.statusCode = ServerStatusCode.BadRequest.rawValue
                
                return
            }
            
            // search for user with specified username and password
            
            let fetchRequest = NSFetchRequest(entityName: "user")
            
            let usernamePredicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: "username"),
                rightExpression: NSExpression(forConstantValue: username!),
                modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
                type: NSPredicateOperatorType.EqualToPredicateOperatorType,
                options: NSComparisonPredicateOptions.CaseInsensitivePredicateOption)
            
            let passwordPredicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: "password"),
                rightExpression: NSExpression(forConstantValue: password!),
                modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
                type: NSPredicateOperatorType.EqualToPredicateOperatorType,
                options: NSComparisonPredicateOptions.NormalizedPredicateOption)
            
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType,
                subpredicates: [usernamePredicate, passwordPredicate])
            
            // dont prefetch values
            fetchRequest.includesPropertyValues = false
            
            // execute request
            
            var error: NSError?
            
            var user: User?
            
            self.managedObjectContext.performBlockAndWait({ () -> Void in
                
                user = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)?.first as? User
            })
            
            // internal error
            if error != nil {
                
                response.statusCode = ServerStatusCode.InternalServerError.rawValue
                
                return
            }
            
            // incorrect username or password
            if user == nil {
                
                response.statusCode = ServerStatusCode.Forbidden.rawValue
                
                return
            }
            
            // create new session
            
            var token: String?
            
            self.managedObjectContext.performBlockAndWait({ () -> Void in
                
                let session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: self.managedObjectContext) as Session
                
                // create new token
                session.token = SessionTokenWithLength(self.sessionTokenLength)
                
                token = session.token
            })
            
            
            
        })
    }
}

// MARK: - Private Constants

private let ServerApplicationSupportFolderURL = NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.LocalDomainMask, appropriateForURL: nil, create: false, error: nil)?.URLByAppendingPathComponent("PedidoServer")
