//
//  StaffUser.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class StaffUser: User {

    @NSManaged public var type: NSNumber
    @NSManaged public var ordersAssigned: NSSet?
    
    public func validateType(inout newValue: NSNumber, error outError: NSErrorPointer) -> Bool {
        
        if (StaffUserType(rawValue: newValue.integerValue) == nil) {
            
            // create error
            
            return false
        }
        
        return true
    }
}

// MARK: - Enumerations

public enum StaffUserType: Int {
    
    case Undefined      = 0
    case Waiter         = 1
    case Delivery       = 2
    case Management     = 98
    case Admin          = 99
    
}