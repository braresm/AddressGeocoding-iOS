//
//  AddressMap.swift
//  inty
//
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct AddressMap: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var mapModel = MapModel.shared
    private var db = Firestore.firestore()
    @State private var suggestions: [AddressItem] = []
    @State private var currentAddressItem: AddressItem?
    @State private var addr = ""
    
    var body: some View {
        VStack {
            TextField("Enter an address", text: $addr)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Button("Add address") {
                    if addr.isEmpty { return }
                    guard let address = currentAddressItem else { return }
                    appState.addressItems.append(address)
                                        
                    db.collection("addresses").addDocument(data: [
                        "alias": address.alias,
                        "latitude":  address.latitude!,
                        "longitude": address.longitude!
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                                        
                    addr = ""
                    currentAddressItem = nil
                }
 
                Spacer()
 
                Button("Find address") {
                    
                    mapModel.getLocation(address: addr, delta: 1) { address in
                        currentAddressItem = address
                    }
                }
            }
            .padding([.leading, .trailing])
                                    
            Map(coordinateRegion: $mapModel.region, showsUserLocation: true, annotationItems: mapModel.locations) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
            .ignoresSafeArea()
            .accentColor(Color(.systemRed))
            .onAppear {
                mapModel.checkIfLocationServiceIsEnables()
            }
        }

    }
}

struct AddressMap_Previews: PreviewProvider {
    static var previews: some View {
        AddressMap()
    }
}
