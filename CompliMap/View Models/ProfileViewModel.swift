//
//  ProfileViewModel.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject, StateManager {
    @Published var name: String
    @Published var user: User
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    @Published var error: Error?
    @Published var isWorking = false
    
    private let authService: AuthService
    
    init(user: User, authService: AuthService) {
        self.name = user.name
        self.user = user
        self.imageURL = user.imageURL
        self.authService = authService
    }
    
    func signOut() {
        withStateManagingTask(perform: authService.signOut)
    }
    
    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withStateManagingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}
