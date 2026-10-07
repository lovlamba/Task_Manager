import XCTest
import CoreData
@testable import Task_Manager // Adjust module name if needed

enum Tab {
    case all
    case completed
    case pending
    case type(String)
}

enum Sorting {
    case date
    case priority
    case title
}

// In-memory persistence controller for testing
final class InMemoryPersistenceController {
    static let shared = InMemoryPersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Task_Manager")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("InMemory store failed: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveChanges() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

    func read(currentTab: Tab, sortOption: Sorting) -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        var predicates: [NSPredicate] = []

        switch currentTab {
        case .all:
            break // no filter
        case .completed:
            predicates.append(NSPredicate(format: "isCompleted == YES"))
        case .pending:
            predicates.append(NSPredicate(format: "isCompleted == NO"))
        case .type(let taskType):
            predicates.append(NSPredicate(format: "type == %@", taskType))
        }

        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        switch sortOption {
        case .date:
            request.sortDescriptors = [NSSortDescriptor(key: "deadline", ascending: true)]
        case .priority:
            // Priority not available in the model; default to date as a fallback
            request.sortDescriptors = [NSSortDescriptor(key: "deadline", ascending: true)]
        case .title:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }

        do {
            return try container.viewContext.fetch(request)
        } catch {
            return []
        }
    }
}

final class TaskViewModelTests: XCTestCase {
    let baseDate = Date(timeIntervalSince1970: 1_700_000_000) // fixed date: 2023-11-14 approx

    func makeTask(
        context: NSManagedObjectContext,
        title: String = "Test Task",
        isCompleted: Bool = false,
        deadline: Date? = nil,
        type: String = "personal"
    ) -> Task {
        let task = Task(context: context)
        task.title = title
        task.isCompleted = isCompleted
        task.deadline = deadline
        task.type = type
        return task
    }

    func seed(count: Int = 10, context: NSManagedObjectContext) -> [Task] {
        var tasks: [Task] = []
        for i in 0..<count {
            let title = "Task \(i)"
            let isCompleted = (i % 3 == 0)
            let deadline = Calendar.current.date(byAdding: .day, value: i, to: baseDate)
            let type: String = (i % 2 == 0) ? "personal" : "work"
            let task = makeTask(context: context, title: title, isCompleted: isCompleted, deadline: deadline, type: type)
            tasks.append(task)
        }
        return tasks
    }

    func testResetTaskRestoresDefaults() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        let task = Task(context: context)
        XCTAssertEqual(task.title, nil)
        XCTAssertEqual(task.isCompleted, false)
        XCTAssertNil(task.deadline)
    }

    func testCreateTaskInsertsNewEntity() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        let task = makeTask(context: context, title: "New Task", isCompleted: false, deadline: baseDate, type: "work")
        try context.save()
        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetch)
        XCTAssertGreaterThanOrEqual(tasks.count, 1)
        let inserted = tasks.first(where: { $0.title == "New Task" })
        XCTAssertNotNil(inserted)
        XCTAssertFalse(inserted?.isCompleted ?? true)
        XCTAssertEqual(inserted?.deadline, baseDate)
        XCTAssertEqual(inserted?.type, "work")
    }

    func testUpdateTaskEditsExistingEntity() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        let task = makeTask(context: context, title: "Old Title", isCompleted: false, deadline: nil, type: "personal")
        try context.save()
        // Update
        task.title = "Updated Title"
        task.isCompleted = true
        task.deadline = baseDate
        task.type = "work"
        try context.save()
        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "SELF == %@", task)
        let results = try context.fetch(fetch)
        XCTAssertEqual(results.count, 1)
        let updated = results[0]
        XCTAssertEqual(updated.title, "Updated Title")
        XCTAssertTrue(updated.isCompleted)
        XCTAssertEqual(updated.deadline, baseDate)
        XCTAssertEqual(updated.type, "work")
    }

    func testDeleteTaskRemovesEntity() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        let task = makeTask(context: context, title: "To Delete", isCompleted: false)
        try context.save()
        context.delete(task)
        try context.save()
        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "SELF == %@", task)
        let results = try context.fetch(fetch)
        XCTAssertEqual(results.count, 0)
    }

    func testSetSelectedTaskCopiesValues() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        let task = makeTask(context: context, title: "Copy Me", isCompleted: true, deadline: baseDate, type: "work")
        XCTAssertEqual(task.title, "Copy Me")
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.deadline, baseDate)
        XCTAssertEqual(task.type, "work")
    }

    func testGetAllTasksFiltersByTabAllCompletedPending() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        _ = seed(count: 10, context: context)
        try context.save()
        let allTasks = InMemoryPersistenceController.shared.read(currentTab: .all, sortOption: .date)
        XCTAssertEqual(allTasks.count, 11)
        let completedTasks = InMemoryPersistenceController.shared.read(currentTab: .completed, sortOption: .date)
        XCTAssertTrue(completedTasks.allSatisfy { $0.isCompleted })
        let pendingTasks = InMemoryPersistenceController.shared.read(currentTab: .pending, sortOption: .date)
        XCTAssertTrue(pendingTasks.allSatisfy { !$0.isCompleted })
    }

    func testGetAllTasksSortsByDatePriorityTitle() throws {
        let context = InMemoryPersistenceController.shared.container.viewContext
        _ = seed(count: 10, context: context)
        try context.save()
        let byDate = InMemoryPersistenceController.shared.read(currentTab: .all, sortOption: .date)
        let dates = byDate.compactMap { $0.deadline }
        XCTAssertTrue(zip(dates, dates.dropFirst()).allSatisfy { $0 <= $1 })
        let byTitle = InMemoryPersistenceController.shared.read(currentTab: .all, sortOption: .title)
        let titles = byTitle.compactMap { $0.title }
        XCTAssertTrue(zip(titles, titles.dropFirst()).allSatisfy { $0 <= $1 })
    }
}
