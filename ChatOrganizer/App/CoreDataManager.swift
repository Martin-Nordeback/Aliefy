//
//  CoreDataManager.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-03.
//

import CoreData
import Foundation

class CoreDataManager {
    // Declare a constant 'persistentContainer' to manage the Core Data stack
    let persistentContainer: NSPersistentContainer
    // Declare a singleton object of the CoreDataManager class, ensuring that only one instance is ever created
    static let shared = CoreDataManager()


    // Private initializer to prevent creating multiple instances of the class
    private init() {
        // Initialize the persistent container with the given data model name
        persistentContainer = NSPersistentContainer(name: "HistoryModel")
        // Load the persistent store and handle any errors
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core data store failed \(error.localizedDescription)")
            }
        }
    }
}
