//
//  MapView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @StateObject var viewModel: MapViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPurple))
            .onAppear() {
                viewModel.checkLocationServicesEnabled()
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel(user: User.testUser))
    }
}
