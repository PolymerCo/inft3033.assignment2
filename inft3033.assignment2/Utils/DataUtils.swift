//
//  DataUtils.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 7/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import CoreData

/**
 Utility methods for managing CoreData instances
 */
class DataUtils {
    
    /**
     Gets the current ManagedObjectContext within the ViewController
     - Returns: The ManagedObjectContect
     */
    public static func getManagedObject() -> NSManagedObjectContext {
        return ViewController.modelContainer.viewContext
    }
    
    /**
     Gets an entity using the current ManagedObjectContext with a specific entity string
     - Parameter for: The entity name
     - Returns: The respective entity
     */
    public static func getEntity(for entity: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entity, in: getManagedObject())!
    }
    
    /**
     Fetches all the objects within CoreData for a given entity name
     - Parameter for: The entity name
     - Returns: An array of managed objects
     */
    public static func fetchObject(for entity: String) throws -> [NSManagedObject] {
        return try getManagedObject().fetch(NSFetchRequest<NSManagedObject>(entityName: entity))
    }
}
