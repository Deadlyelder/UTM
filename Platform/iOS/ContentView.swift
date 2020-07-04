//
// Copyright © 2020 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

struct ContentView: View {
    @State private var editMode = false
    @StateObject private var data = UTMData()
    @State private var newPopupPresented = false
    @State private var newVMScratchPresented = false
    
    var body: some View {
        NavigationView {
            List(data.virtualMachines, id: \.self) { vm in
                NavigationLink(
                    destination: VMDetailsView(config: vm.configuration, screenshot: vm.screenshot.image),
                    label: {
                        //FIXME: update title name/logo when saving configuration
                        VMCardView(title: { Text(vm.configuration.name) }, editAction: {}, runAction: {}, logo: .constant(nil) )
                    })
            }.listStyle(SidebarListStyle())
            .navigationTitle("UTM")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { newPopupPresented.toggle() }, label: {
                        Label("New VM", systemImage: "plus").labelStyle(IconOnlyLabelStyle())
                    })
                    .actionSheet(isPresented: $newPopupPresented) {
                        let sheet = ActionSheet(title: Text("New VM"),
                                                message: Text("Would you like to pick a template?"),
                                                buttons: [
                                                    .default(Text("Template"), action: newVMFromTemplate),
                                                    .default(Text("Advanced"), action: { newVMScratchPresented.toggle() })
                                                ])
                        return sheet
                    }
                }
            }
            .sheet(isPresented: $newVMScratchPresented) {
                NavigationView {
                    VMSettingsView(config: UTMConfiguration(name: data.newDefaultName()))
                }
            }
            VMPlaceholderView()
        }.environmentObject(data)
    }
    
    private func newVMFromTemplate() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
