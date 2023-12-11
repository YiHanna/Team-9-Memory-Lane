//
//  Comment.swift
//  MemoryLane
//
//  Created by Hanna Luo on 12/6/23.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Codable, Comparable, Identifiable {
    @DocumentID var id: String?
    var post_id: DocumentReference
    var user_id: String
    var time: Timestamp
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case post_id
        case user_id
        case time
        case text
    }
  
    static func < (lhs: Comment, rhs: Comment) -> Bool {
      return (lhs.time.dateValue()) < (rhs.time.dateValue())
    }
}
