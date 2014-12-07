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
    @NSManaged public var name: String
    @NSManaged public var sessions: NSSet?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // set date created
        self.dateCreated = NSDate()
    }
}

// MARK: - Enumerations

public enum UserFunction: String {
    
    /// Function to change the password. The input JSON keys are:
    ///
    /// - oldPassword
    /// - newPassword
    case ChangePassword = "ChangePassword"
}