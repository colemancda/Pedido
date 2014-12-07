//
//  Session.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class Session: NSManagedObject {

    @NSManaged public var dateCreated: NSDate
    @NSManaged public var expiryDate: NSDate
    @NSManaged public var token: String
    @NSManaged public var user: User
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // set date created
        self.dateCreated = NSDate()
    }
}
