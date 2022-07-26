//
//  ProfileView.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI

enum ProfileTab {
    case myPosts
    case map
}

struct ProfileView: View {
    @EnvironmentObject private var factory: ViewModelFactory
    @StateObject var viewModel: ProfileViewModel
    @State private var selectedTab: ProfileTab = .myPosts
    
    var body: some View {
            VStack {
                ProfileImage(url: viewModel.imageURL)
                    .frame(width: 100, height: 100)
                ImagePickerButton(imageURL: $viewModel.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Text(viewModel.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ProfileTabView(selectedTab: $selectedTab)
                VStack {
                    switch selectedTab {
                        case .myPosts:
                            NavigationView {
                                ProfilePostListView(viewModel: factory.makePostsViewModel(filter: .author(viewModel.user)), locationViewModel: factory.makeMapsViewModel())
                            }
                        case .map:
                            NavigationView {
                                ProfileMapView(mapViewModel: factory.makeMapsViewModel(), postViewModel: factory.makePostsViewModel(filter: .author(viewModel.user)), repoV2: PostsRepositoryV2(user: viewModel.user))
                            }
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                Button("Sign Out", action: {
                    viewModel.signOut()
                })
                
            }
        .alert("Error", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}

struct ProfileTabView: View {
    @Binding var selectedTab: ProfileTab
    
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
                    Text("Your Compliments")
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
                    Text("Compliment Map")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .map ? .blue : .primary )
            }
            Spacer()
            .buttonStyle(TabButtonStyle())
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(user: User.testUser, authService: AuthService()))
    }
}
