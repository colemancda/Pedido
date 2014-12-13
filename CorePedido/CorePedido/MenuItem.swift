//
//  MenuItem.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class MenuItem: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var price: NSNumber
    @NSManaged public var currencyLocaleIdentifier: String
    @NSManaged public var establishments: NSSet?
    @NSManaged public var images: NSSet?
    @NSManaged public var localizedDescriptions: NSSet?
    @NSManaged public var orderItems: NSSet?

}
