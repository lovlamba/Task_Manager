    //
    //  ColourSettingsView.swift
    //  Task Manager
    //
    //  Created by Lov Lamba on 09/03/25.
    //

import SwiftUI

struct ColourSettingsView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Color")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 15){
                ForEach(AccentColour.allCases,id: \.self){color in
                    Circle()
                        .fill(Color(color.rawValue))
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
                            taskModel.taskColor = color
                        }
                }
            }
            .padding(.top,10)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.top,30)
    }
}
