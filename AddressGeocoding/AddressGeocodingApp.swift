//
//  AddressGeocodingApp.swift
//  AddressGeocoding
//
//  Created by Balutoiu Rares Mihai on 21/03/2023.
//

import SwiftUI
import Firebase

class AppState: ObservableObject {
    @Published var addressItems: [AddressItem] = []    
    @Published var listsNavigationBarDisplay = false
    @Published var mapModel = MapModel.shared
}

@main
struct AddressGeocodingApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
    }
  
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
