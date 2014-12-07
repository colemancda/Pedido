//
//  Define.swift
//  CorePedido
//
//  Created by Alsey Coleman Miller on 12/7/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/** The managed object model for the CorePedido framework. */
public let CorePedidoManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSBundle(identifier: "com.colemancda.Pedido")!.URLForResource("Model", withExtension: "momd")!)!