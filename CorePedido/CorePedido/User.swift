//
//  User.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {

    @NSManaged public var username: String
    @NSManaged public var password: String
    @NSManaged public var email: String?
    @NSManaged public var dateCreated: NSDate

}
