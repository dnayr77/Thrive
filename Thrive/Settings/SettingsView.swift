//
//  SettingsView.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/4/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionInfo: SessionInfo
    @State var homeViewToggle = [true, true, true, true, true, true]
    @State var isEditing = false
    @State var isInit = false
    @State var isAddHome = false
    
    var body: some View {
        
            List {
                Section(header: Text("Home Views")) {
                    ForEach(sessionInfo.homeViews, id: \.self) { view in
                        Toggle(isOn: $homeViewToggle[view.index!]) {
                            Text(view.name)
                        }
                    }
                    .onMove(perform: onMove)
                    .onDelete(perform: onDelete)
                    AddHomeViewButton()
                   
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: saveAction) {
                            Text("Save Changes")
                        }
                        Spacer()
                    }
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .listStyle(GroupedListStyle())
        .navigationBarItems(trailing: trailingButton)
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
        .onAppear{
            for index in 0..<sessionInfo.homeViews.count {
                self.homeViewToggle[index] = sessionInfo.homeViews[index].shown!
            }
            self.isInit = true
        }
    }
    
    //ForEach(sessionInfo.homeViewArray, id: \.self) { view in
     //   Toggle(isOn: $homeViewToggle[view.index!]) {
    //        Text(view.name)
    //    }
    //}
    
    private func saveAction() {
        sessionInfo.updateHomeViews(shownArray: homeViewToggle)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        sessionInfo.homeViews.move(fromOffsets: source, toOffset: destination)
        sessionInfo.updateHomeViews()
    }
    
    private func onDelete(offsets: IndexSet) {
        sessionInfo.homeViews.remove(atOffsets: offsets)
        sessionInfo.updateHomeViews()
    }
    
    private var trailingButton: some View {
            
            Text(self.isEditing == true ? "Done" : "Edit")
                .contentShape(Rectangle())
                .frame(height: 44, alignment: .trailing)
                .onTapGesture {
                    self.$isEditing.wrappedValue.toggle()
            }

    }
}

struct AddHomeViewButton: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var sessionInfo: SessionInfo
    @State var showAddAction = false
    @State var activeSheet: ActiveSheet?
    @State var option: String = "" {
        didSet {
            print("nice")
            sessionInfo.addHomeView(name: self.option)
        }
    }

    var body: some View {
        VStack {
        HStack {
            Spacer()
            Button(action: { showAddAction.toggle() }) {
                Text("Add View")
            }
            Spacer()
        }
        .actionSheet(isPresented: $showAddAction) {
            self.generateActionSheet(options: sessionInfo.homeNotShown)
        }
    }
    }
    
    func generateActionSheet(options: [String]) -> ActionSheet {
        let buttons = options.enumerated().map { i, option in
            Alert.Button.default(Text(option), action: { self.option = option } )
        }
        return ActionSheet(title: Text("Select an option"),
                   buttons: buttons + [Alert.Button.cancel()])
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //SettingsView()
        EmptyView()
    }
}
