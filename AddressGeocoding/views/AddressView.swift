//
//  Address.swift
//  inty
//

import SwiftUI
import FirebaseFirestore

struct AddressView: View {
    //    @State private var editMode = EditMode.inactive
    @EnvironmentObject private var appState: AppState
    @Environment(\.isPresented) var isPresented
    @State var needRefresh: Bool = false
    @State private var addMode = false
    @State private var inputText = ""
    private var db = Firestore.firestore()
    
    var AddButton: some View {
        Button( addMode ? "Done" : "Add", action: {
            if (addMode && !inputText.isEmpty) {
                addItem()
            }

            addMode.toggle()
        })
    }
    
    var body: some View {
        NavigationView {
            
            if (addMode) {
                AddressMap()
            } else {
                List {
                                                            
                    Section {
                        ForEach(appState.addressItems) { addr in

                            VStack {
//                                Text(addr.alias)
                                NavigationLink(destination: MapViewContent(selectedAddress: addr)) {
                                    Text(addr.alias)
                                }
                            }
                        }
                        .onDelete(perform: deleteItem)
                        .onMove(perform: moveItem)
                    } header: {
                        Text("List of available destinations")
                    }
                }
                .refreshable {
                    appState.addressItems.removeAll()
                    let docRef = db.collection("addresses")
                    
                    docRef.getDocuments { (snapshot, error) in
                        
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }

                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                print(data["alias"]!)
                                let alias: String = data["alias"] as! String
                                let latitude: Double = data["latitude"] as! Double
                                let longitude: Double = data["longitude"] as! Double
                                
                                appState.addressItems.append(AddressItem(alias: alias, latitude: latitude, longitude: longitude))                                
                            }
                        }
                    }
                    
//                    appState.addressItems = [
//                        AddressItem(alias: "NYC", latitude: 40.71, longitude: -74),
//                        AddressItem(alias: "Boston", latitude: 42.36, longitude: -71.05)
//                    ]
                    
                    
                }
                .toolbar {
                    EditButton()                    
                }
            }
            
        }
        .navigationBarTitle(Text("Address"))
        .navigationBarItems(trailing: AddButton)
    }
    
    private func addItem() {
//        appState.addressItems.append(AddressItem(alias: inputText))
        inputText = ""
    }
    
    private func deleteItem(at offsets: IndexSet) {
        appState.addressItems.remove(atOffsets: offsets)
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        appState.addressItems.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct Address_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
    }
}
