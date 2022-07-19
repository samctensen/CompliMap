//
//  MainTabView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var factory: ViewModelFactory
    
    var body: some View {
        TabView {
            NavigationView {
                MapView(viewModel: factory.makeMapsViewModel())
            }
            .tabItem {
                Label("Map", systemImage: "location.north.line")
            }
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel())
            }
            .tabItem {
                Label("Local Radius", systemImage: "mappin.and.ellipse")
            }
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel())
            }
            .tabItem {
                Label("Daily Feed", systemImage: "figure.stand.line.dotted.figure.stand")
            }
            ProfileView(viewModel: factory.makeProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "brain.head.profile")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(ViewModelFactory.preview)
    }
}
