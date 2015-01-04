//
//  LocalizedText.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class LocalizedText: NSManagedObject {

    @NSManaged public var locale: String
    @NSManaged public var text: String
    @NSManaged public var menuItemLocalizedDescription: MenuItem?
}
