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
    @NSManaged public var menuItem: MenuItem

}
