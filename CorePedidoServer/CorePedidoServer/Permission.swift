//
//  Permission.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func PermissionForRequest(request: ServerRequest, session: Session?, managedObject: NSManagedObject?, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
    
    switch request.entity.name! {
        
    case "User":
        return UserPermisssionForRequest(request, session, managedObject as? User, key, context)
        
    case "Session":
        return SessionPermisssionForRequest(request, session, managedObject as? Session, key, context)
        
    default:
        return ServerPermission.ReadOnly
    }
}