//
//  HomeView.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI

enum Route {
    case taskDetailView
    case taskCreationView
}

struct HomeView: View {
    @StateObject var taskModel: TaskViewModel = .init()
    @State private var navigationPath: [Route] = []
    @Namespace var animation
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    @Environment(\.self) var env
    @State var isNewTask: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome User")
                            .font(.callout)
                        Text("Let's get things done!")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.vertical)
                    
                    CustomSegmentedBar()
                        .padding(.top,5)
                    
                    LazyVStack(spacing: 20){
                        TaskListView(currentTab: taskModel.currentTab) { (task: Task) in
                            TaskCellView(task: task)
                                .environmentObject(taskModel)
                                .onTapGesture {
                                    navigationPath.append(.taskDetailView)
                                    taskModel.editTask = task
                                    taskModel.setupTask()
                                    self.isNewTask = false
                                }
                        }
                    }
                    .padding(.top,20)
                }
                .padding()
            }
            .overlay(alignment: .bottom) {
                Button {
                    self.isNewTask = true
                    taskModel.resetTaskData()
                    navigationPath.append(.taskCreationView)
                } label: {
                    Label {
                        Text("Add Task")
                            .font(.callout)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(systemName: "plus.app.fill")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(.black,in: Capsule())
                }
                .padding(.top,10)
                .frame(maxWidth: .infinity)
                .background{
                    LinearGradient(colors: [
                        .white.opacity(0.05),
                        .white.opacity(0.4),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                }
            }
            .navigationBarTitle("Task Manager")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .taskDetailView :
                    TaskDetailView(navigationPath: $navigationPath)
                        .environmentObject(taskModel)
                        .navigationBarBackButtonHidden()
                case .taskCreationView :
                    TaskCreationView(navigationPath: $navigationPath)
                        .environmentObject(taskModel)
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomSegmentedBar()->some View{
        let tabs = ["All","Completed","Pending"]
        HStack(spacing: 0){
            ForEach(tabs,id: \.self){tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab{
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
            }
        }
    }
}
