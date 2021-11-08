//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 06/10/2021.
//

import Foundation
import CoreData

open class CoreDataStack {
    private let modelName: String
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (_,_) in})
        return container
    }()
    public lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    public func saveContext() {
        guard viewContext.hasChanges else { return }
        try? viewContext.save()
    }
}
