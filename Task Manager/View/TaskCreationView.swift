//
//  TaskCreationView.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI

struct TaskCreationView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var navigationPath: [Route]
    @Environment(\.self) var env
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 12){
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        navigationPath.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }

            ColourSettingsView(taskModel: self.taskModel)
            
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
            .overlay(alignment: .bottomTrailing) {
                Button {
                    if !taskModel.isTaskCompleted{
                        taskModel.showDatePicker.toggle()
                    }
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $taskModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top,8)
                    .disabled(taskModel.isTaskCompleted)
            }
            .padding(.top,10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $taskModel.taskDescription)
                    .frame(maxWidth: .infinity)
                    .padding(.top,8)
                    .disabled(taskModel.isTaskCompleted)
            }
            .padding(.top,10)
            
            Divider()
            
            let taskTypes: [String] = ["Low","Medium","High"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Priority")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12){
                    ForEach(taskTypes,id: \.self){type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(taskModel.taskType == type ? .white : .black)
                            .background{
                                if taskModel.taskType == type{
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                }else{
                                    Capsule()
                                        .strokeBorder(.black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                if !taskModel.isTaskCompleted{
                                    withAnimation{taskModel.taskType = type}
                                }
                            }
                    }
                }
                .padding(.top,8)
            }
            .padding(.vertical,10)
            
            Divider()
            
            Button {
                    if taskModel.addTask(context: env.managedObjectContext){
                        navigationPath.removeAll()
                    }
            } label: {
                Text("Save Task")
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
            .disabled(taskModel.taskTitle == "")
            .opacity(taskModel.taskTitle == "" ? 0.6 : 1)
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if taskModel.showDatePicker{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            taskModel.showDatePicker = false
                        }
                    
                    DatePicker.init("", selection: $taskModel.taskDeadline,in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white,in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: taskModel.showDatePicker)
        }
    }
}

// if let editTast = taskModel.editTask{
        //                                env.managedObjectContext.delete(editTast)
        //                                try? env.managedObjectContext.save()
        //                                env.dismiss()
        //                            }
