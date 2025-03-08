//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "All"
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Low"
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
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.taskDescription = taskDescription
        task.isCompleted = isTaskCompleted
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    func resetTaskData(){
        taskType = "Low"
        taskColor = "Yellow"
        taskTitle = ""
        taskDescription = ""
        taskDeadline = Date()
        isTaskCompleted = false
        editTask = nil
    }
    
    func setupTask(){
        if let editTask = editTask {
            taskType = editTask.type ?? "Low"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDescription = editTask.taskDescription ?? ""
            taskDeadline = editTask.deadline ?? Date()
            isTaskCompleted = editTask.isCompleted
        }
    }
}
