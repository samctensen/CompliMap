//
//  MainTabView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI

enum Tab {
    case feed
    case map
    case profile
}

struct MainTabView: View {
    @EnvironmentObject private var factory: ViewModelFactory
    @State private var selectedTab: Tab = .feed
    
//    var body: some View {
//        TabView {
//            NavigationView {
//                PostsList(viewModel: factory.makePostsViewModel())
//            }
//            .tabItem {
//                Label("Local Radius", systemImage: "mappin.and.ellipse")
//            }
//            NavigationView {
//                MapView(viewModel: factory.makeMapsViewModel())
//            }
//            .tabItem {
//                Label("Map", systemImage: "location.north.line")
//            }
//            ProfileView(viewModel: factory.makeProfileViewModel())
//                .tabItem {
//                    Label("Profile", systemImage: "brain.head.profile")
//                }
//        }
//    }
    
    var body: some View {
        VStack {
            switch selectedTab {
                case .feed:
                    NavigationView {
                        PostsList(viewModel: factory.makePostsViewModel())
                    }
                case .map:
                    NavigationView {
                        MapView(viewModel: factory.makeMapsViewModel())
                    }
                case .profile:
                    NavigationView {
                        ProfileView(viewModel: factory.makeProfileViewModel())
                    }
            }
            CustomTabView(selectedTab: $selectedTab)
                .frame(height: 50)
        }
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    public var showNewPostForm = false
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .feed
            }
            label: {
                VStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Feed")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .feed ? .blue : .primary )
            }
            Spacer()
            Button {
                selectedTab = .map
            }
            label: {
                VStack {
                    Image(systemName: "map")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Map")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .map ? .blue : .primary )
            }
            Spacer()
            Button {
                selectedTab = .profile
            }
            label: {
                VStack {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Profile")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .profile ? .blue : .primary )
            }
            Button {
                //showNewPostForm = true
            }
            label: {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 2)
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.primary)
                        .frame(width: 72, height: 72)
                }
                .offset(y: -32)
            }
            .buttonStyle(TabButtonStyle())
        }
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9: 1)
            .scaleEffect(configuration.isPressed ? 0.98: 1)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(ViewModelFactory.preview)
    }
}
