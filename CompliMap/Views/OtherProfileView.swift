//
//  ProfileView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI

enum OtherProfileTab {
    case myPosts
    case map
}

struct OtherProfileView: View {
    @EnvironmentObject private var factory: ViewModelFactory
    @StateObject var viewModel: OtherProfileViewModel
    @StateObject var postsRepo: PostsRepositoryV2
    @State private var selectedTab: OtherProfileTab = .myPosts
    
    var body: some View {
            VStack {
                ProfileImage(url: viewModel.imageURL)
                    .frame(width: 100, height: 100)
                Text(viewModel.name)
                    .font(.title2)
                    .bold()
                    .padding()
                Button(action: {}) {
                    Text("Follow")
                }
                .tint(.purple)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.automatic)
                .controlSize(.regular)
                OtherProfileTabView(selectedTab: $selectedTab)
                VStack {
                    switch selectedTab {
                        case .myPosts:
                            NavigationView {
                                ProfilePostListView(viewModel: factory.makePostsViewModel(filter: .author(viewModel.user)), postsRepo: PostsRepositoryV2(user: factory.user), locationViewModel: factory.makeMapsViewModel())
                            }
                        case .map:
                            NavigationView {
                                OtherProfileMapView(mapViewModel: factory.makeMapsViewModel(), repoV2: PostsRepositoryV2(otherUser: viewModel.user))
                            }
                    }
                }
            }
    }
}
struct OtherProfileTabView: View {
    @Binding var selectedTab: OtherProfileTab
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .myPosts
            }
            label: {
                VStack {
                    Image(systemName: "list.bullet.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Posts")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .myPosts ? .blue : .primary )
            }
            Spacer()
            Button {
                selectedTab = .map
            }
            label: {
                VStack {
                    Image(systemName: "map.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("CompliMap")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .map ? .blue : .primary )
            }
            Spacer()
            .buttonStyle(TabButtonStyle())
        }
    }
}

struct OtherProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(user: User.testUser, authService: AuthService()))
    }
}
