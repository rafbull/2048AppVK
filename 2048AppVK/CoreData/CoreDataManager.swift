//
//  CoreDataManager.swift
//  2048AppVK
//
//  Created by Rafis on 10.04.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "_048AppVK")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Methods for working with data entities
    func fetchSavedTiles() -> [Tile] {
        let tilesFetchRequest = Tile.fetchRequest()
        var savedTiles = [Tile]()
        
        let sortPositionY = NSSortDescriptor(key: "positionY_", ascending: true)
        let sortPositionX = NSSortDescriptor(key: "positionX_", ascending: true)
        tilesFetchRequest.sortDescriptors = [sortPositionY, sortPositionX]
        
        do {
            savedTiles = try viewContext.fetch(tilesFetchRequest)
        } catch {
            print("Can't get saved tiles: \(error.localizedDescription)")
        }
        
        return savedTiles
    }
    
    func deleteNoteFromCoreData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("Can't delete tiles: \(error.localizedDescription)")
        }
    }
}
