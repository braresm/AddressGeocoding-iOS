//
//  AddressItem.swift
//  inty
//
//

import SwiftUI
import MapKit

struct AddressItem: Identifiable, Codable {
    var id = UUID()
    var alias: String
    var isHeader: Bool = false
    var isFooter: Bool = false
    var latitude: Double?
    var longitude: Double?
}
