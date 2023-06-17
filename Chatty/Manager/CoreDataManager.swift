//
//  CoreDataManager.swift
//  Chatty
//
//  Created by Clyde on 2023/06/17.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private var modelName: String?

    private init() {}

    func configure(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelName = modelName else {
            fatalError("Model name is not set. Call configure(modelName:) before accessing the persistent container.")
        }

        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}
