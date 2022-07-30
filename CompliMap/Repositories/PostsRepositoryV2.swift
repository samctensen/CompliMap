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
    
    init(otherUser: User) {
        self.user = otherUser
        loadUsersPosts(user: otherUser)
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
                 
                    //let timeStamp = postdata["timestamp"] as? Timestamp ?? Timestamp()
                    let postTimestamp = postdata["timestamp"] as? Timestamp ?? Timestamp()
                    let timezoneOffset =  Int64(TimeZone.current.secondsFromGMT())
                    let epochDate = postTimestamp.seconds
                    let timezoneEpochOffset = (epochDate + timezoneOffset)
                     
                    // 4) Finally, create a date using the seconds offset since 1970 for the local date.
                    let timeZoneOffsetDate = Date(timeIntervalSince1970: TimeInterval(timezoneEpochOffset))
                   
                    //let timeStampDate = dateFormatter.date(from: timestampString)
                    let latitude = postdata["latitude"] as? Double ?? 0
                    let longitude = postdata["longitude"] as? Double ?? 0
                    
                    let postAuthor = User(id: authorID, name: authorName, imageURL: authorImageURL)
                    let post = Post(title: "", content: postContent, author: postAuthor, imageURL: postImageURL, isFavorite: false, timestamp: timeZoneOffsetDate , id: postIDUUID, latitude: latitude, longitude: longitude)
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
        let query = database.collection("posts").order(by: "timestamp", descending: true)
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
