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

}

// MARK: - Enumerations

public enum StaffUserType: UInt {
    
    case Undefined      = 0
    case Waiter         = 1
    case Delivery       = 2
    case Management     = 98
    case Admin          = 99
    
}