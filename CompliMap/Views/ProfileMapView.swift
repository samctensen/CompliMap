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
        var mapView = Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPurple))
            .onAppear() {
                mapViewModel.checkLocationServicesEnabled()
                
            }
        Group {
            switch postViewModel.posts {
            case .loading:
                ProgressView()
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Posts",
                    message: error.localizedDescription,
                    retryAction: {
                        postViewModel.fetchPosts()
                    }
                )
            case .empty:
                EmptyListView(
                    title: "No Posts",
                    message: "There aren’t any posts yet."
                )
            case let .loaded(posts):
                ScrollView {
                    ForEach(posts) { post in
                       // var postFlag = MKPointAnnotation()
                        //postFlag.coordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
                    }
                    .animation(.none, value: posts)
                }
            }
        }
    }
}

struct ProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: MapViewModel(user: User.testUser))
    }
}
