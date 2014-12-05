//
//  ExternalDeliveryTarget.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/4/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class ExternalDeliveryTarget: DeliveryTarget {

    @NSManaged public var additionalInstructions: String?
    @NSManaged public var address: String

}
