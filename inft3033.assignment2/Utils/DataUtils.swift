//
//  DataUtils.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 7/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import CoreData

class DataUtils {
    
    public static func getManagedObject() -> NSManagedObjectContext {
        return ViewController.modelContainer.viewContext
    }
    
    public static func getEntity(for entity: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entity, in: getManagedObject())!
    }
    
    public static func newObject(for entity: String) -> NSManagedObject {
        return NSManagedObject(entity: getEntity(for: entity), insertInto: getManagedObject())
    }
    
    public static func fetchObject(for entity: String) throws -> [NSManagedObject] {
        return try getManagedObject().fetch(NSFetchRequest<NSManagedObject>(entityName: entity))
    }
}
