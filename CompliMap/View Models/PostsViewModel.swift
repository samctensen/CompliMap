//
//  PostsViewModel.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import Foundation
import SwiftUI

@MainActor
class PostsViewModel: ObservableObject {
    enum Filter {
        case all, author(User), favorites
    }
    
    @Published var posts: Loadable<[Post]> = .loading
    @Published var loadedPosts: [CLLocationCoordinate2D] = []
    
    private let filter: Filter
    private let postsRepository: PostsRepositoryProtocol
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case let .author(author):
            return ""
        case .favorites:
            return "Favorites"
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makeNewPostViewModel(lat: Double, lon: Double) -> FormViewModel<Post> {
        return FormViewModel<Post>(
            initialValue: Post(title: "", content: "", author: postsRepository.user, latitude: lat, longitude: lon),
            action: { [weak self] post in
                try await self?.postsRepository.create(post)
                self?.posts.value?.insert(post, at: 0)
            }
        )
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(
            post: post,
            deleteAction: {
                guard postsRepository.canDelete(post) else { return nil }
                return { [weak self] in
                    try await self?.postsRepository.delete(post)
                    self?.posts.value?.removeAll { $0 == post }
                }
            }(),
            favoriteAction: { [weak self] in
                let newValue = !post.isFavorite
                try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
                guard let i = self?.posts.value?.firstIndex(of: post) else { return }
                self?.posts.value?[i].isFavorite = newValue
            }
        )
    }
}

private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case let .author(author):
            return try await fetchPosts(by: author)
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
