//
//  TaskListView.swift
//  Task Manager
//
//  Created by Lov Lamba on 08/03/25.
//

import SwiftUI
import CoreData

struct TaskListView<Content: View,T>: View where T: NSManagedObject {
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(currentTab: Tab, sortOption: Sorting,@ViewBuilder content: @escaping (T)->Content){
        var predicate: NSPredicate!
        if currentTab.rawValue == "Pending"{
            predicate = NSPredicate(format: "isCompleted == false")
        }else if currentTab.rawValue == "Completed"{
            predicate = NSPredicate(format: "isCompleted == true")
        }
        var sort = NSSortDescriptor(key: #keyPath(Task.deadline), ascending: true)
        if sortOption == Sorting.priority{
            sort = NSSortDescriptor(key: #keyPath(Task.type), ascending: true)
        }
        else if sortOption == Sorting.title{
            sort = NSSortDescriptor(key: #keyPath(Task.title), ascending: true)
        }
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [sort], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group{
            if request.isEmpty{
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }
            else{
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
