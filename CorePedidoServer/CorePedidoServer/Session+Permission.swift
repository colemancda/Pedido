//
//  Session+Permission.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func SessionPermisssionForRequest(request: ServerRequest, session: Session?, managedObject: Session?, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
    
    // user can view their own sessions, but not change them
    if managedObject === session?.user {
        
        return ServerPermission.ReadOnly
    }
    
    // invisible to everyone else
    return ServerPermission.NoAccess
}