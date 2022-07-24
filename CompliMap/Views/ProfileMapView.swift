//
//  MapView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import SwiftUI

struct ProfileMapView: View {
    
    @StateObject var mapViewModel: MapViewModel
    @StateObject var postViewModel: PostsViewModel

    var body: some View {
        Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPurple))
            .onAppear() {
                mapViewModel.checkLocationServicesEnabled()
                
            }
    }
}

struct ProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel(user: User.testUser))
    }
}
