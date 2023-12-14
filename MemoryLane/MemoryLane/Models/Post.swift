//
//  Post.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation
import SwiftUI


struct Post: Identifiable, Codable, Comparable {
    // MARK: Fields
    @DocumentID var id: String?
    var user_id: DocumentReference
    var date: Timestamp
    var location: GeoPoint
    var description: String
    var photo: String?
    var num_likes: Int
    var post_time: Timestamp
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case date
        case location
        case description
        case photo
        case num_likes
        case post_time
    }    
  
  func comment(text: String) {
    dbDocuments.commentPost(post: self, comment: text)
  }
  
  static func == (lhs: Post, rhs: Post) -> Bool {
    lhs.date == rhs.date
  }
  
  static func < (lhs: Post, rhs: Post) -> Bool {
    return (lhs.date.dateValue()) < (rhs.date.dateValue())
  }
}
