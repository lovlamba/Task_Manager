//
//  TaskDetailView.swift
//  Task Manager
//
//  Created by Lov Lamba on 09/03/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Environment(\.self) var env
    @Namespace var animation
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 12){
            Text("Task Detail")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        taskModel.openEditTask = false
                        env.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskColor)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,30)
            
            Divider()
                .padding(.vertical,10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Due Date")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + taskModel.taskDeadline.formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskTitle)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskDescription)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Priority")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskType)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.vertical,10)
            
            Divider()
            
            if !taskModel.isTaskCompleted{
                Button {
                    self.isPresented = true
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
        .frame(maxHeight: .infinity,alignment: .top)
        .padding()
        .fullScreenCover(isPresented: $isPresented){
            TaskCreationView()
                .environmentObject(taskModel)
        }
    }
}
