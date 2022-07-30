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
    @State public var selectedTab: Tab = .feed
    
    var body: some View {
        VStack {
            let postViewModel = factory.makePostsViewModel()
            let mapViewModel = factory.makeMapsViewModel()
            let postsRepo = PostsRepositoryV2(user: factory.user)
            switch selectedTab {
                case .feed:
                    NavigationView {
                        PostsList(viewModel: postViewModel, postRepo: postsRepo)
                    }
                case .map:
                    NavigationView {
                        MapView(locationViewModel: mapViewModel, postsRepo: postsRepo)
                    }
                case .profile:
                    NavigationView {
                        ProfileView(viewModel: factory.makeProfileViewModel())
                    }
            }
            CustomTabView(postViewModel: postViewModel, mapViewModel: mapViewModel, postsRepo: postsRepo, selectedTab: $selectedTab)
                .frame(height: 50)
        }
    }
}

struct CustomTabView: View {
    @Environment(\.colorScheme) var colorScheme
    public var postViewModel: PostsViewModel
    public var mapViewModel: MapViewModel
    public var postsRepo: PostsRepositoryV2
    
    @Binding var selectedTab: Tab
    @State private var showNewPostForm = false
    
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
                showNewPostForm.toggle()
            }
            label: {
                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 2)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                    }
                    else {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 2)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(Color.primary)
                            .frame(width: 72, height: 72)
                    }
                }
                .offset(y: -32)
            }
            .buttonStyle(TabButtonStyle())
            .sheet(isPresented: $showNewPostForm) {
                NewPostForm(viewModel: postViewModel.makeNewPostViewModel(lat: mapViewModel.latitude, lon: mapViewModel.longitude), locationViewModel: mapViewModel)
            }
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
