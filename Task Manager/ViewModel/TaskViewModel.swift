//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskColor: AccentColour = .yellow
    @Published var taskDeadline: Date = Date()
    @Published var taskType: Priority = .low
    @Published var isTaskCompleted: Bool = false
    let dataService = PersistenceController.shared
    @Published var selectedTask: Task?
    @Published var showDatePicker: Bool = false
    @Published var currentTab: Tab = .all
    @Published var sortOption: Sorting = .date
    
    init() {
        getAllTasks()
    }
    
    func getAllTasks() {
        tasks = dataService.read(currentTab: currentTab, sortOption: sortOption)
    }
    
    func createTask() {
        if let selectedTask = selectedTask {
            self.updateTask(task: selectedTask)
        }
        else{
            let entity = Task(context: dataService.container.viewContext)
            self.updateTask(task: entity)
        }
    }
    
    func resetTask(){
        taskTitle = ""
        taskDescription = ""
        taskColor = .yellow
        taskDeadline = Date()
        taskType = .low
        isTaskCompleted = false
        selectedTask = nil
    }
    
    func updateTask(task: Task) {
        task.color = taskColor.rawValue
        task.deadline = taskDeadline
        task.taskDescription = taskDescription
        task.title = taskTitle
        task.type = taskType.rawValue
        task.isCompleted = isTaskCompleted
        dataService.saveChanges()
        self.resetTask()
    }
    
    func setSelectedTask() {
        taskColor = AccentColour.getColour(colour: selectedTask?.color ?? AccentColour.yellow.rawValue)
        taskDeadline = selectedTask?.deadline ?? Date()
        taskDescription = selectedTask?.taskDescription ?? ""
        taskTitle = selectedTask?.title ?? ""
        taskType = Priority.getPriority(priority: selectedTask?.type ?? Priority.low.rawValue)
        isTaskCompleted = selectedTask?.isCompleted ?? false
    }
    
    func deleteTask(Task: Task) {
        dataService.container.viewContext.delete(Task)
        dataService.saveChanges()
        getAllTasks()
    }
}

enum Tab: String, CaseIterable{
    case all = "All"
    case completed = "Completed"
    case pending = "Pending"
}

enum AccentColour: String, CaseIterable{
    case yellow = "Yellow"
    case green = "Green"
    case red = "Red"
    case blue = "Blue"
    case purple = "Purple"
    case orange = "Orange"
    
    static func getColour(colour: String) -> AccentColour{
        switch colour{
        case "Yellow":
            return .yellow
        case "Green":
            return .green
        case "Red":
            return .red
        case "Blue":
            return .blue
        case "Purple":
            return .purple
        case "Orange":
            return .orange
        default:
            return .yellow
        }
    }
}

enum Priority: String, CaseIterable{
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    static func getPriority(priority: String) -> Priority{
        switch priority{
        case "High":
            return .high
        case "Medium":
            return .medium
        case "Low":
            return .low
        default:
            return .low
        }
    }
}

enum Sorting: String, CaseIterable{
    case date = "Sort By Due Date"
    case priority = "Sort By Priority"
    case title = "Sort By Title"
}
