//
//  Prompt.swift
//  MemoryLane
//
//  Created by Cindy Chen on 12/2/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation


struct Prompt: Identifiable, Codable {
    // MARK: Fields
    @DocumentID var id: String?
    var text: String
    var on: Bool
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case text
        case on
    }
}
