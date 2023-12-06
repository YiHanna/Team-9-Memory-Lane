//
//  User.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var email: String
    var password: String
    var name: String
    var username: String
    var schools: [String: String]
    var hometown: String
    var current_city: String
    var friends: [DocumentReference]
    var posts_liked: [String]
    var photo: String?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
        case name
        case username
        case schools
        case hometown
        case current_city
        case friends
        case posts_liked
        case photo
    }
}
