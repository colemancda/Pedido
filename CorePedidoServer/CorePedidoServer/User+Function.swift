//
//  User+Function.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func UserEntityFunctions() -> [String] {
    
    return [UserFunction.ChangePassword.rawValue]
}

func UserPerformFunction(function: UserFunction, managedObject: User, context: NSManagedObjectContext, user: User?, recievedJsonObject: [String : AnyObject]?) -> (ServerFunctionCode, [String : AnyObject]?) {
    
    switch function {
        
    case .ChangePassword:
        
        if recievedJsonObject == nil {
            
            return (ServerFunctionCode.RecievedInvalidJSONObject, nil)
        }
        
        // get values from JSON
        let oldPassword = recievedJsonObject!["oldPassword"] as? String
        let newPassword = recievedJsonObject!["newPassword"] as? String
        
        if oldPassword == nil || newPassword == nil {
            
            return (ServerFunctionCode.RecievedInvalidJSONObject, nil)
        }
        
        var validOldPassword = false
        
        context.performBlockAndWait({ () -> Void in
            
            validOldPassword = (oldPassword == managedObject.password)
        })
        
        if !validOldPassword {
            
            return (ServerFunctionCode.CannotPerformFunction, nil)
        }
        
        // change password...
        
        context.performBlockAndWait({ () -> Void in
            
            managedObject.password = newPassword!
        })
        
        // return success
        return (ServerFunctionCode.PerformedSuccesfully, nil)
    }
}