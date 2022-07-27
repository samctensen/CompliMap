//
//  PostsRepositoryV2.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/24/22.
//

import Foundation
import Firebase
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class PostsRepositoryV2: ObservableObject {
    @Published var allPosts: [Post] = []
    @Published var otherUserPosts: [Post] = []
    @Published var myPosts: [Post] = []
    @Published var allPostLocations: [MapLocation] = []
    @Published var otherUserPostLocations: [MapLocation] = []
    @Published var myPostLocations: [MapLocation] = []
    @Published var database = Firestore.firestore()
    @Published var user: User
    
    init(user: User) {
        self.user = user
        loadMyPosts()
        loadAllPosts()
    }
    
    func loadPostsFromCollection(snapshotDocs: [QueryDocumentSnapshot]) -> ([Post], [MapLocation]) {
        var postsReturn: [Post] = []
        var locationsReturn: [MapLocation] = []
                for document in snapshotDocs {
                    let postdata = document.data()
                    
                    let author = postdata["author"] as? [String:Any]
                    
                    let authorID = author?["id"] as? String ?? ""
                    let authorName = author?["name"] as? String ?? ""
                    let authorimage = author?["imageURL"] as? String ?? ""
                    let authorImageURL = URL(string: authorimage)
//                    let authorID = author["id"] as? String
//                    let authorPic = author["imageURL"] as? String ?? ""
//                    let authorName = author["name"] as? String ?? ""
                    
                    let postIDString = postdata["id"] as? String ?? ""
                    let postIDUUID = UUID(uuidString: postIDString) ?? UUID()
                    let postContent = postdata["content"] as? String ?? ""
                    let postImage = postdata["imageURL"] as? String ?? ""
                    let postImageURL = URL(string: postImage)
                 
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let timestampString = postdata["timestamp"] as? Date ?? Date.now
                    //let date = dateFormatter.date(from:timestampString) ?? Date.now
                    
                   
                    //let timeStampDate = dateFormatter.date(from: timestampString)
                    let latitude = postdata["latitude"] as? Double ?? 0
                    let longitude = postdata["longitude"] as? Double ?? 0
                    
                    let postAuthor = User(id: authorID, name: authorName, imageURL: authorImageURL)
                    let post = Post(title: "", content: postContent, author: postAuthor, imageURL: postImageURL, isFavorite: false, timestamp: timestampString, id: postIDUUID, latitude: latitude, longitude: longitude)
                    postsReturn.append(post)
                    
                    let postCoordinateStructure = MapLocation(name: authorName, latitude: latitude, longitude: longitude)
                    locationsReturn.append(postCoordinateStructure)
        }
        return (postsReturn, locationsReturn)
    }
    
    func loadMyPosts() {
        let query = database.collection("posts").whereField("author.id", isEqualTo: user.id)
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let returnTuple = self.loadPostsFromCollection(snapshotDocs: snapshot.documents)
                self.myPosts = returnTuple.0
                self.myPostLocations = returnTuple.1
            }
        }
    }
     
    func loadUsersPosts(user: User) {
        let query = database.collection("posts").whereField("author.id", isEqualTo: user.id)
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let returnTuple = self.loadPostsFromCollection(snapshotDocs: snapshot.documents)
                self.otherUserPosts = returnTuple.0
                self.otherUserPostLocations = returnTuple.1
            }
        }
    }
    
    func loadAllPosts() {
        let query = database.collection("posts")
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let returnTuple = self.loadPostsFromCollection(snapshotDocs: snapshot.documents)
                self.allPosts = returnTuple.0
                self.allPostLocations = returnTuple.1
            }
        }
    }
}
