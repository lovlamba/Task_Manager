//
//  TaskCellView.swift
//  Task Manager
//
//  Created by Lov Lamba on 09/03/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var navigationPath: [Route]
    
    var body: some View{
        LazyVStack(spacing: 20){
            if taskModel.tasks.isEmpty{
                ContentUnavailableView(
                    "No" + (taskModel.currentTab == .all ? " " : " \(taskModel.currentTab.rawValue) ") + "Task",
                    systemImage: (taskModel.currentTab == .all ? "square.and.pencil" : (taskModel.currentTab == .completed ? "hourglass" : "checkmark.circle.fill")),
                    description: Text((taskModel.currentTab == .all ? "Create your first task and start conquering your day!" : (taskModel.currentTab == .completed ? "Every step counts towards success – stay focused and finish strong!" : "Congratulations! Time to celebrate your hard work and success!")))
                )
                .padding(.top,100.0)
            }
            else{
                ForEach(taskModel.tasks){ task in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack{
                            Text(task.type ?? "")
                                .font(.callout)
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .background{
                                    Capsule()
                                        .fill(.white.opacity(0.3))
                                }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        
                        Text(task.title ?? "")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .padding(.vertical,10)
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            VStack(alignment: .leading, spacing: 10) {
                                Label {
                                    Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                                } icon: {
                                    Image(systemName: "calendar")
                                }
                                .font(.caption)
                                
                                Label {
                                    Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                                } icon: {
                                    Image(systemName: "clock")
                                }
                                .font(.caption)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            
                            if !task.isCompleted{
                                Button {
                                    taskModel.selectedTask = task
                                    taskModel.setSelectedTask()
                                    taskModel.isTaskCompleted = true
                                    taskModel.updateTask(task: task)
                                } label: {
                                    Circle()
                                        .strokeBorder(.black,lineWidth: 1.5)
                                        .frame(width: 25, height: 25)
                                        .contentShape(Circle())
                                }
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(task.color ?? AccentColour.yellow.rawValue))
                    }
                    .onTapGesture {
                        taskModel.selectedTask = task
                        navigationPath.append(.taskDetailView)
                    }
                }
            }
        }
        .padding(.top,20)
    }
}

