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

extension User: PermissionProtocol {
    
    func permisssionForRequest(request: ServerRequest, user: User?, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
        
        // no key (create or delete user)
        if key == nil {
            
            
        }
        
        switch key! {
            
        case username: return ServerPermission.ReadOnly
            
        case password: return ServerPermission.NoAccess
            
        default: return ServerPermission.ReadOnly
        }
    }
}
