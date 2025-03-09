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
                            .foregroundColor(.black)
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
                .foregroundColor(.white)
                .background{
                    Capsule()
                        .fill(.black)
                }
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
