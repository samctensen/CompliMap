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
            annotationItems: repoV2.myPostLocations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LocationMapAnnotationView()
                }
            }
        )
    }
}

struct LocationMapAnnotationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "heart.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(.purple)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.purple)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct ProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser), postsRepo: PostsRepositoryV2(user: User.testUser))
    }
}
