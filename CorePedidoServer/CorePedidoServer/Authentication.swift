//
//  Authentication.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/6/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import NetworkObjects
import CorePedido

func AuthenticationSessionFromRequestHeaders(headers: [String: String], context: NSManagedObjectContext) -> (Session?, NSError?) {
    
    // get token header
    let token = headers["Authorization"]
    
    if token == nil {
        
        return (nil, nil)
    }
    
    let fetchRequest = NSFetchRequest(entityName: "Session")
    
    fetchRequest.predicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: "token"),
        rightExpression: NSExpression(forConstantValue: token!),
        modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
        type: NSPredicateOperatorType.EqualToPredicateOperatorType,
        options: NSComparisonPredicateOptions.NormalizedPredicateOption)
    
    // execute fetch request
    
    var error: NSError?
    
    var session: Session?
    
    context.performBlockAndWait { () -> Void in
        
        session = context.executeFetchRequest(fetchRequest, error: &error)?.first as? Session
    }
    
    // return found session or error
    return (session, error)
}

func Authenticate(withUsername username: String, password: String) -> Session? {
    
    return nil
}