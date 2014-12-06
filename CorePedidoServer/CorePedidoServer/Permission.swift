//
//  Permission.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import NetworkObjects
import CorePedido

protocol PermissionProtocol {
    
    func permisssionForUser(user: User, key: String) -> ServerPermission
}