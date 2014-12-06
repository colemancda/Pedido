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

protocol PermissionProtocol {
    
    func permisssionForRequest(request: ServerRequest, user: User, key: String?, context: NSManagedObjectContext?) -> ServerPermission
}

// MARK: - Default Implementation

extension NSManagedObject: PermissionProtocol {
    
    func permisssionForRequest(request: ServerRequest, user: User, key: String?, context: NSManagedObjectContext?) -> ServerPermission {
        
        return ServerPermission.NoAccess
    }
}