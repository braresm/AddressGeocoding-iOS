//
//  MapView.swift
//  AddressGeocoding
//
//  Created by Creative Ones on 3/28/23.
//

import SwiftUI
import MapKit

struct MapViewContent: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var mapModel = MapModel.shared
    @State private var directions: [String] = []
    @State private var showDirections = false
    let selectedAddress: AddressItem
    
    var body: some View {
        VStack {
            
            MapView(region: mapModel.userRegion, directions: $directions, address: selectedAddress)
            
            Button(action: {
                self.showDirections.toggle()
            }, label: {
                Text("Show directions")
            })
            .disabled(directions.isEmpty)
                .padding()
        }

        .sheet(isPresented: $showDirections, content: {
            VStack(spacing: 0) {
                Text("Directions")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Divider().background(Color.blue)

                List(0..<self.directions.count, id: \.self) { i in
                    Text(self.directions[i]).padding()
                }
            }
        })
        
    }
}

struct MapView: UIViewRepresentable {
    var region: MKCoordinateRegion
    typealias UIViewType = MKMapView
    @Binding var directions: [String]
    public var address: AddressItem
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
                
        // NYC
//        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.71, longitude: -74))
                                
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: address.latitude ?? 40.71, longitude: address.longitude ?? -74))
        
        print(region.center.latitude, region.center.longitude)
        // Boston
//        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 42.36, longitude: -71.05))
        
        let request = MKDirections.Request()

        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
            
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
}

