//
//  MapView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import SwiftUI

struct OtherProfileMapView: View {
    
    @StateObject var mapViewModel: MapViewModel
    @StateObject var repoV2: PostsRepositoryV2
    
    var body: some View {
        Map(
            coordinateRegion: $mapViewModel.region,
            showsUserLocation: false,
            annotationItems: repoV2.otherUserPostLocations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LocationMapAnnotationView()
                }
            }
        )
    }
}

struct OtherProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser), postsRepo: PostsRepositoryV2(user: User.testUser))
    }
}
