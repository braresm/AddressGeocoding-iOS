//
//  EditButton.swift
//  inty

import SwiftUI

struct AddButton: View {
    @State private var addMode = EditMode.inactive
    
    var body: some View {
        Button( addMode.isEditing ? "Done" : "Add", action: {
            addMode.isEditing ? (addMode = EditMode.inactive) : (addMode = EditMode.active)
        })
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
