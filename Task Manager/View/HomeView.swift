//
//  HomeView.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI
import CoreData

enum Route {
    case taskDetailView
    case taskCreationView
}

struct HomeView: View {
    @StateObject var taskModel: TaskViewModel = .init()
    @State private var navigationPath: [Route] = []
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme
    @State private var isScaleChange = false
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    HStack{
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome User")
                                .font(.callout)
                            Text("Let's get things done!")
                                .font(.title2.bold())
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.vertical)
                        
                        Spacer()
                        SortMenuView()
                    }
                    CustomSegmentedBarView()
                        .padding(.top,5)
                    
                    TaskListView(navigationPath: $navigationPath)
                }
                .padding()
            }
            .overlay(alignment: .bottom) {
                AddTaskButtonView()
            }
            .navigationBarTitle("Task Manager")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .taskDetailView :
                    TaskDetailView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                        .scaleEffect(isScaleChange ? 0.5 : 1)
                        .animation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 100.0))
                case .taskCreationView :
                    TaskCreationView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .environmentObject(taskModel)
        .onAppear{
            if !hasLaunchedBefore && taskModel.tasks.isEmpty{
                for count in 0..<5{
                    taskModel.taskTitle = "Task" + "\(count)"
                    taskModel.taskDescription = "Description" + "\(count)"
                    taskModel.taskDeadline = Date.now
                    taskModel.taskType = count == 0 || count == 3 ? .low : (count == 2 ? .medium : .high)
                    taskModel.taskColor = AccentColour.allCases[count]
                    taskModel.isTaskCompleted = count == 0 || count == 3 || count == 4 ? false : true
                    taskModel.createTask()
                }
            }
            hasLaunchedBefore = true
        }
    }
    
    @ViewBuilder
    func CustomSegmentedBarView()->some View{
        HStack(spacing: 0){
            ForEach(Tab.allCases,id: \.self){ tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? (colorScheme == .dark ? .black : .white) : (colorScheme == .dark ? .white : .black))
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab{
                            Capsule()
                                .fill(colorScheme == .dark ? .white : .black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{
                            taskModel.currentTab = tab
                            taskModel.getAllTasks()
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func SortMenuView()->some View{
        Menu {
            ForEach(Sorting.allCases,id: \.self) { sortCase in
                Button(action: {
                    taskModel.sortOption = sortCase
                    taskModel.getAllTasks()
                }){
                    HStack{
                        if taskModel.sortOption  == sortCase{
                            Image(systemName: "checkmark" )
                        }
                        Text(sortCase.rawValue)
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.and.down.text.horizontal")
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .foregroundColor(.black)
    }
    
    @ViewBuilder
    func AddTaskButtonView()->some View{
        Button {
            taskModel.resetTask()
            navigationPath.append(.taskCreationView)
        } label: {
            Label {
                Text("Add Task")
                    .font(.callout)
                    .fontWeight(.semibold)
            } icon: {
                Image(systemName: "plus.app.fill")
            }
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(colorScheme == .dark ? .white : .black,in: Capsule())
        }
        .padding(.top,10)
        .frame(maxWidth: .infinity)
        .background{
            LinearGradient(colors: [
                (colorScheme == .dark ? .black.opacity(0.05) : .white.opacity(0.05)),
                (colorScheme == .dark ? .black.opacity(0.04) : .white.opacity(0.04)),
                (colorScheme == .dark ? .black.opacity(0.07) : .white.opacity(0.07)),
                (colorScheme == .dark ? .black : .white)
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        }
    }
}
