//
//  Relationship.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/28/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/** Class representing to-many relationship. */
class ToManyRelationship {
    
    // MARK: - Properties
    
    let managedObject: NSManagedObject
    
    let key: String
    
    // MARK: - Initialization
    
    init(managedObject: NSManagedObject, key: String) {
        
        self.managedObject = managedObject
        self.key = key
    }
    
    // MARK: - Methods
    
    func isMember(managedObject: NSManagedObject) -> Bool {
        
        let set = self.managedObject.valueForKey(self.key) as NSSet
        
        return set.containsObject(managedObject)
    }
}