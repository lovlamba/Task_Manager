//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: Tab = .all
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskColor: AccentColour = .yellow
    @Published var taskDeadline: Date = Date()
    @Published var taskType: Priority = .low
    @Published var showDatePicker: Bool = false
    @Published var isTaskCompleted: Bool = false
    @Published var editTask: Task?
    
    func addTask(context: NSManagedObjectContext)->Bool{
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor.rawValue
        task.deadline = taskDeadline
        task.type = taskType.rawValue
        task.taskDescription = taskDescription
        task.isCompleted = isTaskCompleted
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    func resetTaskData(){
        taskType = .low
        taskColor = .yellow
        taskTitle = ""
        taskDescription = ""
        taskDeadline = Date()
        isTaskCompleted = false
        editTask = nil
    }
    
    func setupTask(){
        if let editTask = editTask {
            taskTitle = editTask.title ?? ""
            taskType = Priority.getPriority(priority: editTask.type ?? "")
            taskColor = AccentColour.getColour(colour: editTask.color ?? "")
            taskDescription = editTask.taskDescription ?? ""
            taskDeadline = editTask.deadline ?? Date()
            isTaskCompleted = editTask.isCompleted
        }
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
