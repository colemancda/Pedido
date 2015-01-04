//
//  RelationshipViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 1/3/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CorePedido
import CorePedidoClient

/** View controller for editing to-many relationships between entities. Displays the contents of a many-to-one relationship. */
class RelationshipViewController: FetchedResultsViewController {
    
    // MARK: - Properties
    
    var relationship: (NSManagedObject, String)? {
        
        didSet {
            
            // create fetch request
            if relationship != nil {
                
                let (managedObject, key) = self.relationship!
                
                let relationshipDescription = managedObject.entity.relationshipsByName[key] as? NSRelationshipDescription
                
                assert(relationshipDescription != nil, "Relationship \(key) not found on \(managedObject.entity.name!) entity")
                
                assert(relationshipDescription!.toMany, "Relationship \(key) on \(managedObject.entity.name!) is not to-many")
                
                assert(!relationshipDescription!.inverseRelationship!.toMany, "Inverse relationship \(!relationshipDescription!.inverseRelationship!.toMany) is to-many")
                
                let fetchRequest = NSFetchRequest(entityName: relationshipDescription!.destinationEntity!.name!)
                
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: Store.sharedStore.resourceIDAttributeName, ascending: true)]
                
                fetchRequest.predicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: relationshipDescription!.inverseRelationship!.name), rightExpression: NSExpression(forConstantValue: managedObject), modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: NSComparisonPredicateOptions.NormalizedPredicateOption)
                
                self.fetchRequest = fetchRequest
                
            }
            else {
                
                self.fetchRequest = nil
            }
        }
    }
}
