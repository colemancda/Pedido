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

func permissionForRequest(request: ServerRequest, user: User?, managedObject: NSManagedObject?, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
    
    switch request.entity.name! {
        
    case "User":
        return UserPermisssionForRequest(request, user, managedObject as? User, key, context)
        
    default:
        return ServerPermission.ReadOnly
    }
}