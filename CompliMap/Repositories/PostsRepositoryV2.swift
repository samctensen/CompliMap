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
    @Published var posts: [Post] = []
    @Published var postCoordinates: [MapLocation] = []
    @Published var database = Firestore.firestore()
    @Published var user: User
    
    init(user: User) {
        self.user = user
        loadPostsFromCollection()
    }
    
    func loadPostsFromCollection() {
        var query = database.collection("posts").whereField("author.id", isEqualTo: user.id)
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let postdata = document.data()
                    
                    let author = postdata["author"] as? [String:Any]
                    
                    let authorID = author?["id"] as? String ?? ""
                    let authorName = author?["name"] as? String ?? ""
                    let authorPic = author?["imageURL"] as? String ?? ""
                    let authorImageURL = URL(string: authorPic)
//                    let authorID = author["id"] as? String
//                    let authorPic = author["imageURL"] as? String ?? ""
//                    let authorName = author["name"] as? String ?? ""
                    
                    let postIDString = postdata["id"] as? String ?? ""
                    let postIDUUID = UUID(uuidString: postIDString) ?? UUID()
                    let postContent = postdata["content"] as? String ?? ""
                 
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let timestampString = postdata["timestamp"] as? Date ?? Date.now
                    //let date = dateFormatter.date(from:timestampString) ?? Date.now
                    
                   
                    //let timeStampDate = dateFormatter.date(from: timestampString)
                    let latitude = postdata["latitude"] as? Double ?? 0
                    let longitude = postdata["longitude"] as? Double ?? 0
                    let postCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let postAuthor = User(id: authorID, name: authorName, imageURL: authorImageURL)
                    let post = Post(title: "", content: postContent, author: postAuthor, imageURL: authorImageURL, isFavorite: false, timestamp: timestampString, id: postIDUUID, latitude: latitude, longitude: longitude)
                    self.posts.append(post)
                    
                    let postCoordinateStructure = MapLocation(name: authorName, latitude: latitude, longitude: longitude)
                    self.postCoordinates.append(postCoordinateStructure)
                }
            }
        }
    }
    
    func loadMyPosts() {
        loadUsersPosts(user: self.user)
    }
     
    func loadUsersPosts(user: User) {
        posts.removeAll()
        let postsReference = database.collection("posts").whereField("author.id", isEqualTo: user.id)
        //loadPostsFromCollection(collectionReference: postsReference)
    }
}
