//
//  Image.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class Image: NSManagedObject {

    @NSManaged public var data: NSData
    @NSManaged public var establishment: Establishment?
    @NSManaged public var menuItem: MenuItem?

}
