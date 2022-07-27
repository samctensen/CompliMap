//
//  MapView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @StateObject var locationViewModel: MapViewModel
    @StateObject var postsRepo: PostsRepositoryV2

    var body: some View {
        Map(
            coordinateRegion: $locationViewModel.region,
            showsUserLocation: false,
            annotationItems: postsRepo.allPostLocations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LocationMapAnnotationView()
                }
            })
            .ignoresSafeArea()
            .accentColor(Color(.systemYellow))
            .onAppear() {
                locationViewModel.checkLocationServicesEnabled()
            }
            .navigationTitle("Map")
            .toolbar {
                Button {
                
                }
                label: {
                    Label("New Post", systemImage: "heart.text.square")
                }
            }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser), postsRepo: PostsRepositoryV2(user: User.testUser))
    }
}
