//
//  Home.swift
//  inty
//
//

import SwiftUI

struct Navigation: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    HStack() {
                        
                        NavigationLink(destination: AddressView().navigationTitle("Address")
                                       , label: {
                            HStack {
                                Spacer()
                                
                                Text("Address")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                                Image(systemName: "note.text.badge.plus")
                                    .padding(.trailing)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        })
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.width * 0.15)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .cornerRadius(8)
                        
                        
                    }
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)                                      
                    
                    Spacer()
                    
                }
                
            }
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
