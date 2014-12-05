//
//  Order.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class Order: NSManagedObject {

    @NSManaged public var paymentMethod: NSNumber
    @NSManaged public var status: NSNumber
    @NSManaged public var deliveryTarget: DeliveryTarget
    @NSManaged public var establishment: Establishment
    @NSManaged public var orderItems: NSSet?
    @NSManaged public var clientUser: ClientUser?
    @NSManaged public var staffUserAssigned: StaffUser?
    @NSManaged public var dateCreated: NSDate
}

// MARK: - Enumerations

/** Type of payment method. */
public enum PaymentMethod: Int {
    
    case NotApplicable  = -1
    case Cash           = 0
    case CreditCard     = 1
    case ApplePay       = 2
    case PayPal         = 3
}

/** Status of the order. */
public enum OrderStatus: Int {
    
    case Cancelled  = -1
    case Backlog    = 0
    case InTransit  = 1
    case Delivered  = 2
}