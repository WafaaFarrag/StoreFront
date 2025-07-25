//
//  PersistenceController.swift
//  StoreFront
//
//  Created by wafaa farrag on 25/07/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // The persistent container for CoreData
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "StoreFront") // Use your CoreData model's name
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }

    // Access to the view context
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}
