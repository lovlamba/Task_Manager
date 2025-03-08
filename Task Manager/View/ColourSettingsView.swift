//
//  ColourSettingsView.swift
//  Task Manager
//
//  Created by Lov Lamba on 09/03/25.
//

import SwiftUI

struct ColourSettingsView: View {
    @ObservedObject var taskModel: TaskViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Color")
                .font(.caption)
                .foregroundColor(.gray)
            
            let colors: [String] = ["Yellow","Green","Blue","Purple","Red","Orange"]
            
            HStack(spacing: 15){
                ForEach(colors,id: \.self){color in
                    Circle()
                        .fill(Color(color))
                        .frame(width: 25, height: 25)
                        .background{
                            if taskModel.taskColor == color{
                                Circle()
                                    .strokeBorder(.gray)
                                    .padding(-3)
                            }
                        }
                        .contentShape(Circle())
                        .onTapGesture {
                            if !taskModel.isTaskCompleted{
                                taskModel.taskColor = color
                            }
                        }
                }
            }
            .padding(.top,10)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.top,30)
    }
}
