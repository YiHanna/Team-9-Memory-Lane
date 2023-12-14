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
  
  func getDate() -> String{
    let date2 = date.dateValue()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter.string(from: date2)
  }
  
  func getYear() -> Int {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date.dateValue())
    return year
  }
  
  func getLocation(completion: @escaping (String) -> Void) {
      let geocoder = CLGeocoder()
      let location = CLLocation(latitude: location.latitude, longitude: location.longitude)

      geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
          if let error = error {
              print("Error reverse geocoding: \(error.localizedDescription)")
              completion("")
          } else if let placemark = placemarks?.first {
              let city = placemark.locality ?? "Unknown"
              let state = placemark.administrativeArea ?? "Unknown"
              completion("\(city), \(state)")
          } else {
              completion("")
          }
      }
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
