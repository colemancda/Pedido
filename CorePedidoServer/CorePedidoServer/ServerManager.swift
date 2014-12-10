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
        let server = Server(dataSource: self,
            delegate: self,
            managedObjectModel: CorePedidoManagedObjectModel(),
            searchPath: "search",
            resourceIDAttributeName: "id",
            prettyPrintJSON: true,
            sslIdentityAndCertificates: nil,
            permissionsEnabled: true)
        
        self.addAuthenticationHandlerToServer(server)
        
        return server
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.server.managedObjectModel)
        
        var error: NSError?
        
        if persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: ServerSQLiteFileURL, options: nil, error: &error) == nil {
            
            NSException(name: NSInternalInconsistencyException, reason: "Could not add persistent store. (\(error!.localizedDescription))", userInfo: nil)
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: Server Configuration Properties
    
    public let sessionTokenLength: UInt = LoadServerSetting(ServerSetting.SessionTokenLength) as? UInt ?? 30
    
    /** The amount of time in secounds the session will last. */
    public let sessionExpiryTimeInterval: NSTimeInterval = LoadServerSetting(ServerSetting.SessionExpiryTimeInterval) as? NSTimeInterval ?? 10000000
    
    public let serverPort: UInt = LoadServerSetting(ServerSetting.ServerPort) as? UInt ?? 8080
    
    // MARK: - Private Properties
    
    private var lastResourceIDByEntityName: [String: UInt] = NSDictionary(contentsOfURL: ServerLastResourceIDByEntityNameFileURL) as? [String: UInt] ?? [String: UInt]()
    
    private var lastResourceIDByEntityNameOperationQueue: NSOperationQueue = {
       
        let operationQueue = NSOperationQueue()
        
        operationQueue.name = "CorePedidoServer.ServerManager lastResourceIDByEntityName Access Queue"
        
        operationQueue.maxConcurrentOperationCount = 1
        
        return operationQueue
        
    }()
    
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
    
    // MARK: - Actions
    
    /** Starts broadcasting the server. */
    public func start() -> NSError? {
        
        // make sure we have the app support folder
        self.createApplicationSupportFolderIfNotPresent()
        
        // setup for empty server
        self.addAdminUserIfEmpty()
        
        // start HTTP server
        return self.server.start(onPort: self.serverPort);
    }
    
    /** Stops broadcasting the server. */
    public func stop() {
        
        self.server.stop();
    }
    
    // MARK: - ServerDataSource
    
    public func server(server: Server, managedObjectContextForRequest request: ServerRequest) -> NSManagedObjectContext {
        
        return self.newManagedObjectContext();
    }
    
    public func server(server: Server, newResourceIDForEntity entity: NSEntityDescription) -> UInt {
        
        return self.newResourceIDForEntity(entity.name!)
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
            
            return (ServerFunctionCode.InternalErrorPerformingFunction, nil)
        }
        
        return PerformFunction(functionName, managedObject, context, session, recievedJsonObject)
    }
    
    // MARK: - ServerDelegate
    
    public func server(server: Server, didEncounterInternalError error: NSError, forRequest request: ServerRequest, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Internal error occurred for request: \(request), userInfo: \(userInfo). (\(error))")
    }
    
    public func server(server: Server, didPerformRequest request: ServerRequest, withResponse response: ServerResponse, userInfo: [ServerUserInfoKey: AnyObject]) {
        
        println("Processed (\(request.requestType.hashValue)) request and responded with: (\(response.statusCode.rawValue)) \(response.JSONResponse?)")
    }
    
    public func server(server: Server, didInsertManagedObject managedObject: NSManagedObject, context: NSManagedObjectContext) {
        
        
    }
    
    public func server(server: Server, statusCodeForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext) -> ServerStatusCode {
        
        return ServerStatusCode.OK
    }
    
    public func server(server: Server, permissionForRequest request: ServerRequest, managedObject: NSManagedObject?, context: NSManagedObjectContext, key: String?) -> ServerPermission {
        
        // get authenticated user from request and return permssions based on authenticated user
        
        let (session, error) = AuthenticationSessionFromRequestHeaders(request.headers, context)
        
        assert(error == nil, "Internal error occurred while trying to get session from authentication headers. (\(error?.localizedDescription))")
        
        // get permissions
        return PermissionForRequest(request, session, managedObject, key, context)
    }
    
    // MARK: - Private Methods
    
    private func newManagedObjectContext() -> NSManagedObjectContext {
        
        // create a new managed object context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        // setup persistent store coordinator
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    private func newResourceIDForEntity(entityName: String) -> UInt {
        
        // create new one
        var newResourceID: UInt = 0
        
        self.lastResourceIDByEntityNameOperationQueue.addOperations([NSBlockOperation(block: { () -> Void in
            
            // get last resource ID and increment by 1
            if let lastResourceID = self.lastResourceIDByEntityName[entityName] {
                
                newResourceID = lastResourceID + 1;
            }
            
            // save new one
            self.lastResourceIDByEntityName[entityName] = newResourceID;
            
            let saved = (self.lastResourceIDByEntityName as NSDictionary).writeToURL(ServerLastResourceIDByEntityNameFileURL, atomically: true)
            
            assert(saved, "Could not save lastResourceIDByEntityName dictionary to disk")
            
        })], waitUntilFinished: true)
        
        return newResourceID
    }
    
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
            
            let fetchRequest = NSFetchRequest(entityName: "User")
            
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
            
            let managedObjectContext = self.newManagedObjectContext()
            
            managedObjectContext.performBlockAndWait({ () -> Void in
                
                user = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)?.first as? User
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
            
            var sessionManagedObjectID: NSManagedObjectID?
            
            managedObjectContext.performBlockAndWait({ () -> Void in
                
                let session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: managedObjectContext) as Session
                
                // set resource id
                session.setValue(self.newResourceIDForEntity("Session"), forKey: self.server.resourceIDAttributeName)
                
                // set user
                session.user = user!
                
                // set expiry date
                session.expiryDate = NSDate(timeInterval: self.sessionExpiryTimeInterval, sinceDate: NSDate())
                
                // create new token
                session.token = SessionTokenWithLength(self.sessionTokenLength)
                
                // set pointers
                token = session.token
                sessionManagedObjectID = session.objectID
                
                // save
                managedObjectContext.save(&error)
            })
            
            // internal error
            if error != nil {
                
                response.statusCode = ServerStatusCode.InternalServerError.rawValue
                
                return
            }
            
            // return token
            
            let jsonData = NSJSONSerialization.dataWithJSONObject(["token": token!], options: NSJSONWritingOptions.allZeros, error: nil)
            
            response.respondWithData(jsonData)
        })
    }
    
    private func addAdminUserIfEmpty() {
        
        let managedObjectContext = self.newManagedObjectContext()
        
        let adminFetchRequest = NSFetchRequest(entityName: "StaffUser")
        
        adminFetchRequest.predicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: "username"),
            rightExpression: NSExpression(forConstantValue: "admin"),
            modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
            type: NSPredicateOperatorType.EqualToPredicateOperatorType,
            options: NSComparisonPredicateOptions.CaseInsensitivePredicateOption)
        
        adminFetchRequest.includesPropertyValues = false
        
        var error: NSError?
        
        var results: [NSManagedObject]?
        
        managedObjectContext.performBlockAndWait { () -> Void in
            
            results = managedObjectContext.executeFetchRequest(adminFetchRequest, error: &error) as? [NSManagedObject]
        }
        
        assert(error == nil, "Error while trying to fetch admin user. (\(error!.localizedDescription))")
        
        // admin found
        if results!.count > 0 {
            
            return
        }
        
        // create new admin
        managedObjectContext.performBlockAndWait { () -> Void in
            
            let admin = NSEntityDescription.insertNewObjectForEntityForName("StaffUser", inManagedObjectContext: managedObjectContext) as StaffUser
            
            // set default values
            admin.username = "admin"
            admin.password = "admin1234"
            admin.name = "Administrator"
            admin.type = StaffUserType.Admin.rawValue
            admin.setValue(0, forKey: self.server.resourceIDAttributeName)
            
            // update lastResourceID
            self.lastResourceIDByEntityName["User"] = self.newResourceIDForEntity("StaffUser");
            
            // save
            managedObjectContext.save(&error)
        }
        
        if error != nil {
            
            NSException(name: NSInternalInconsistencyException, reason: "Error while trying to save new Admin user. (\(error!.localizedDescription))", userInfo: nil).raise()
        }
        
        println("Created admin user")
    }
    
    private func createApplicationSupportFolderIfNotPresent() {
        
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(ServerApplicationSupportFolderURL.path!, isDirectory: nil)
        
        if !fileExists {
            
            var error: NSError?
            
            // create directory
            NSFileManager.defaultManager().createDirectoryAtURL(ServerApplicationSupportFolderURL, withIntermediateDirectories: true, attributes: nil, error: &error)
            
            if error != nil {
                
                NSException(name: NSInternalInconsistencyException, reason: "Could not create application support directory. (\(error!.localizedDescription))", userInfo: nil).raise()
            }
        }
    }
}