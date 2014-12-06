//
//  User+Permission.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/5/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func UserPermisssionForRequest(request: ServerRequest, session: Session?, managedObject: User?, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
    
    // no key specified
    if key == nil {
        
        switch request.requestType {
            
        case .POST: return ServerPermission.EditPermission
        case .DELETE, .PUT:
            
            if session?.user === managedObject {
                
                return ServerPermission.EditPermission
            }
            
            return ServerPermission.ReadOnly
            
        default:
            return ServerPermission.ReadOnly
        }
    }
    
    // permission for property
    
    switch key! {
        
    case "password":
        
        // needs edit permission for initial creation
        if request.requestType == ServerRequestType.POST {
            
            return ServerPermission.EditPermission
        }
        
        return ServerPermission.NoAccess
        
    case "sessions":
        
        // user can only see its own sessions
        if session?.user === managedObject {
            
            return ServerPermission.EditPermission
        }
        
        return ServerPermission.NoAccess
        
    default:
        
        return ServerPermission.ReadOnly
    }
}
