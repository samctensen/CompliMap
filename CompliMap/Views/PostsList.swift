//
//  PostsList.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import SwiftUI

struct PostsList: View {
    @StateObject public var viewModel: PostsViewModel
    @StateObject public var postRepo: PostsRepositoryV2
    
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
                    ForEach(postRepo.allPosts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.fetchPosts()
        }
        .toolbar {
            Button {
                showNewPostForm = true
            } label: {
                Label("Notifcations", systemImage: "bell")
            }
        }
    }
}

extension PostsList {
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
struct PostsList_Previews: PreviewProvider {
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
            let postsRepo2 = PostsRepositoryV2(user: User.testUser)
            let locationViewModel = PostsViewModel(postsRepository: postsRepository)
            NavigationView {
                PostsList(viewModel: locationViewModel, postRepo: postsRepo2)
                    .environmentObject(ViewModelFactory.preview)
            }
        }
    }
}
#endif
