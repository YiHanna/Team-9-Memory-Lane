//
//  Post.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    // MARK: Fields
    @DocumentID var id: String?
    var user_id: DocumentReference
    var date: Timestamp
    var location: GeoPoint
    var description: String
    var photo: String?
    var num_likes: Int
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case date
        case location
        case description
        case photo
        case num_likes
    }
}
