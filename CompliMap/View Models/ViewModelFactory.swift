//
//  ViewModelFactory.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import Foundation

@MainActor
class ViewModelFactory: ObservableObject {
    private let user: User
    private let authService: AuthService
    
    init(user: User, authService: AuthService) {
        self.user = user
        self.authService = authService
    }
    
    func makePostsViewModel(filter: PostsViewModel.Filter = .all) -> PostsViewModel {
        return PostsViewModel(filter: filter, postsRepository: PostsRepository(user: user))
    }
    
    func makeCommentsViewModel(for post: Post) -> CommentsViewModel {
        return CommentsViewModel(commentsRepository: CommentsRepository(user: user, post: post))
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(user: user, authService: authService)
    }
    
    func makeMapsViewModel() -> MapViewModel {
        return MapViewModel(user: user)
    }
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser, authService: AuthService())
}
#endif
