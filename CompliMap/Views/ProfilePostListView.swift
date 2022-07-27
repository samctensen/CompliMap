//
//  PostsList.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI
import MapKit

struct ProfilePostListView: View {
    @StateObject public var viewModel: PostsViewModel
    @StateObject public var postsRepo: PostsRepositoryV2
    @StateObject public var locationViewModel: MapViewModel
    
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        Group {
            switch viewModel.posts {
            case .loading:
                ProgressView()
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Posts",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchPosts()
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
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                            var postLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .sheet(isPresented: $showNewPostForm) {
            NewPostForm(viewModel: viewModel.makeNewPostViewModel(lat: locationViewModel.latitude, lon: locationViewModel.longitude), locationViewModel: locationViewModel)
        }
    }
}

extension ProfilePostListView {
    struct RootView: View {
        @StateObject var viewModel: PostsViewModel
        @StateObject var postsRepo: PostsRepositoryV2
        
        var body: some View {
            NavigationView {
                PostsList(viewModel: viewModel, postRepo: postsRepo)
            }
        }
    }
}

#if DEBUG
struct ProfilePostListView_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let locationViewModel = PostsViewModel(postsRepository: postsRepository)
            let postsRepo = PostsRepositoryV2(user: User.testUser)
            NavigationView {
                PostsList(viewModel: locationViewModel, postRepo: postsRepo)
                    .environmentObject(ViewModelFactory.preview)
            }
        }
    }
}
#endif
