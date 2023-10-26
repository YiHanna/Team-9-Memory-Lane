//
//  User.swift
//  FirebaseDemo
//
//  Created by Cindy Chen on 10/24/23.
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
    }
}
