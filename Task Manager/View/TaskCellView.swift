//
//  TaskCellView.swift
//  Task Manager
//
//  Created by Lov Lamba on 09/03/25.
//

import SwiftUI

struct TaskCellView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Environment(\.self) var env
    @State var task: Task
    
    var body: some View{
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
                        task.isCompleted = true
                        taskModel.isTaskCompleted = true
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black,lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? AccentColour.yellow.rawValue))
        }
    }
}

