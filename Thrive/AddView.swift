//
//  AddView.swift
//  Thrive
//
//  Created by Ryan Dunn on 9/16/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
      // 2
      entity: Task.entity(),
      // 3
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.name, ascending: true)
      ]
    // 4
    )
    
    var tasks: FetchedResults<Task>
    
    var body: some View {
        AddTask { name, date in
          self.addTask(name: name)
        }
    }
    
    func addTask(name: String) {
      // 1
      let newTask = Task(context: managedObjectContext)

      // 2
      newTask.name = name
      newTask.date = Date()

      // 3
      saveContext()
    }
    
    func deleteTask(at offsets: IndexSet) {
      // 1.
      offsets.forEach { index in
        // 2.
        let task = self.tasks[index]

        // 3.
        self.managedObjectContext.delete(task)
      }

      // 4.
      saveContext()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
