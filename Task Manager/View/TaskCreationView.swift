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
            
            ColourSettingsView()
            
            Divider()
                .padding(.vertical,10)
            
            DatePickerView()
            
            Divider()
            
            CustomTextField(text: $taskModel.taskTitle, title: "Title")
            
            Divider()
            
            CustomTextField(text: $taskModel.taskDescription, title: "Description")
            
            Divider()
            
            PriorityCapsuleView()
            
            Divider()
            
            SaveButtonView()
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
    
    @ViewBuilder
    func DatePickerView()->some View{
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
                taskModel.showDatePicker.toggle()
            } label: {
                Image(systemName: "calendar")
                    .foregroundColor(.black)
            }
        }
    }
    
    @ViewBuilder
    func PriorityCapsuleView()->some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 12){
                ForEach(Priority.allCases,id: \.self){type in
                    Text(type.rawValue)
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
                            withAnimation{
                                taskModel.taskType = type
                            }
                        }
                }
            }
            .padding(.top,8)
        }
        .padding(.vertical,10)
    }
    
    @ViewBuilder
    func SaveButtonView()->some View{
        Button {
            taskModel.createTask()
            navigationPath.removeAll()
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
}

struct CustomTextField: View {
    @Binding var text: String
    var title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .frame(maxWidth: .infinity)
                .padding(.top,8)
        }
        .padding(.top,10)
    }
}
