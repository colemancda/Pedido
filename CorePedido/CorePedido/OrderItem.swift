//
//  OrderItem.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class OrderItem: NSManagedObject {

    @NSManaged public var quantity: NSNumber
    @NSManaged public var order: Order
    @NSManaged public var menuItem: MenuItem
}
