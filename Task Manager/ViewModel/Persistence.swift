//
//  Persistence.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Task_Manager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveChanges() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save changes to Core Data.", error.localizedDescription)
            }
        }
    }
    
    func read(currentTab: Tab, sortOption: Sorting) -> [Task] {
        var results: [Task] = []
        var predicate: NSPredicate!
        if currentTab == Tab.pending{
            predicate = NSPredicate(format: "isCompleted == false")
        }else if currentTab == Tab.completed{
            predicate = NSPredicate(format: "isCompleted == true")
        }
        var sort = NSSortDescriptor(key: #keyPath(Task.deadline), ascending: true)
        if sortOption == Sorting.priority{
            sort = NSSortDescriptor(key: #keyPath(Task.type), ascending: true)
        }
        else if sortOption == Sorting.title{
            sort = NSSortDescriptor(key: #keyPath(Task.title), ascending: true)
        }
        let request = NSFetchRequest<Task>(entityName: "Task")
        if let predicate_ = predicate{
            request.predicate = predicate_
        }
        request.sortDescriptors = [sort]
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tasks from Core Data.")
        }
        return results
    }
}
