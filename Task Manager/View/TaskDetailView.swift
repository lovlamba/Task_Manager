//
//  TaskDetailView.swift
//  Task Manager
//
//  Created by Lov Lamba on 09/03/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var navigationPath: [Route]
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme
    @State var presentAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 12){
            Text("Task Detail")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        taskModel.resetTask()
                        navigationPath.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button {
                        self.presentAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
            
            CustomTextView(title: "Task Color", text: taskModel.selectedTask?.color ?? "")
            
            Divider()
                .padding(.vertical,10)
            
            CustomTextView(title: "Due Date", text: (taskModel.selectedTask?.deadline ?? Date()).formatted(date: .abbreviated, time: .omitted) + ", " + (taskModel.selectedTask?.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
            
            Divider()
            
            CustomTextView(title: "Title", text: taskModel.selectedTask?.title ?? "")
            
            Divider()
            
            CustomTextView(title: "Description", text: taskModel.selectedTask?.taskDescription ?? "")
            
            Divider()
            
            CustomTextView(title: "Priority", text: taskModel.selectedTask?.type ?? "")
            
            Divider()
            
            if !(taskModel.selectedTask?.isCompleted ?? false){
                UpdateTaskButtonView()
            }
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .padding()
        .alert(isPresented: $presentAlert) {
            Alert(title: Text("Confirm Deletion"),
                  message: Text("Are you sure you want to delete this task ?"),
                  primaryButton: .destructive(Text("Delete")) {
                if let selectedTask_ = taskModel.selectedTask {
                    taskModel.deleteTask(Task: selectedTask_)
                    navigationPath.removeLast()
                }
            }, secondaryButton: .cancel())
        }
    }
    
    @ViewBuilder
    func UpdateTaskButtonView()->some View{
        Button {
            taskModel.setSelectedTask()
            navigationPath.append(.taskCreationView)
        } label: {
            Text("Update Task")
                .font(.callout)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical,12)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .background(colorScheme == .dark ? .white : .black,in: Capsule())
        }
        .frame(maxHeight: .infinity,alignment: .bottom)
        .padding(.bottom,10)
    }
}

struct CustomTextView: View {
    var title: String
    var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(text)
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.top,8)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.vertical,10)
    }
}
