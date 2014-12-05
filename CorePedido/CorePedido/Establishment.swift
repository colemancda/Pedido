//
//  Establishment.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class Establishment: NSManagedObject {

    @NSManaged public var defaultLanguage: String
    @NSManaged public var location: String
    @NSManaged public var images: NSSet?
    @NSManaged public var menuItems: NSSet?
    @NSManaged public var orders: NSSet?

}
