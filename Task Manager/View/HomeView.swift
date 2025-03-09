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
                case .taskCreationView :
                    TaskCreationView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .environmentObject(taskModel)
    }
    
    @ViewBuilder
    func CustomSegmentedBarView()->some View{
        HStack(spacing: 0){
            ForEach(Tab.allCases,id: \.self){ tab in
                Text(tab.rawValue)
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
                }) {
                    HStack{
                        if taskModel.sortOption  == sortCase{
                            Image(systemName: "checkmark.circle.fill" )
                        }
                        Text(sortCase.rawValue)
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.and.down.text.horizontal")
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
}
