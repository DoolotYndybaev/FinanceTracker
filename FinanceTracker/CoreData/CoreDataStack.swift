//
//  CoreDataStack.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    // NSPersistentContainer — главный контейнер Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinanceTrackerModel") // <- имя .xcdatamodeld файла
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    /// Контекст для чтения и записи
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// Сохраняет изменения, если они есть
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save Core Data context: \(error)")
            }
        }
    }
}
