//
//  PostsRepositoryV2.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/24/22.
//

import Foundation
import Firebase

class PostsRepositoryV2: ObservableObject {
    @Published var posts: [Post] = []
    @Published var database = Firestore.firestore()
    
    func fetchAllPosts() {
        posts.removeAll()
        let postsReference = database.collection("posts")
        postsReference.getDocuments { snapshot, error in
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
                    
                    var postAuthor = User(id: authorID, name: authorName, imageURL: authorImageURL)
                    var post = Post(title: "", content: postContent, author: postAuthor, imageURL: authorImageURL, isFavorite: false, timestamp: timestampString, id: postIDUUID, latitude: latitude, longitude: longitude)
                    
                }
            }
        }
    }
}
