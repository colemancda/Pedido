//
//  Function.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func FunctionsForEntity(entity: NSEntityDescription) -> [String] {
    
    switch entity.name! {
        
    case "User": return UserEntityFunctions()
    default: return []
    }
}

func PerformFunction(function: String, managedObject: NSManagedObject, context: NSManagedObjectContext, user: User?, recievedJsonObject: [String : AnyObject]?) -> (ServerFunctionCode, [String : AnyObject]?) {
    
    switch managedObject.entity.name! {
        
    case "User": return UserPerformFunction(UserFunction(rawValue: function)!, managedObject as User, context, user, recievedJsonObject)
    
    default: return (ServerFunctionCode.InternalErrorPerformingFunction, nil)
    }
}