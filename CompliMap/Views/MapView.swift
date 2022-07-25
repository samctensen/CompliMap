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
    @State private var showNewPostForm = false

    var body: some View {
        Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPurple))
            .onAppear() {
                locationViewModel.checkLocationServicesEnabled()
            }
            .navigationTitle("Map")
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "heart.text.square")
                }
            }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser))
    }
}
