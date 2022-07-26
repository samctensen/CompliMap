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
    @StateObject var repoV2: PostsRepositoryV2
    
    var body: some View {
        Map(
            coordinateRegion: $mapViewModel.region,
            showsUserLocation: false,
            annotationItems: repoV2.postCoordinates,
            annotationContent: { location in
                MapPin(coordinate: location.coordinate, tint: .red)
            }
        )
    }
}

struct ProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser))
    }
}
