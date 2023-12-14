//
//  ViewModel.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation
import Firebase


class LocationViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var searchQuery: String = ""
    @Published var showLocationResults: Bool = false
    
    private var cancellable: AnyCancellable?
    private var completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        
        completer.delegate = self
        
        cancellable = $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { query in
                self.searchForLocations(query)
            }
      showLocationResults = false
    }
    
    private func searchForLocations(_ query: String) {
        completer.queryFragment = query
        showLocationResults = true
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
  
    func selectLocation(_ location: MKLocalSearchCompletion) {
        searchQuery = location.title
        showLocationResults = false
    }
    
    private func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        print("address: \(address)")
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("Geocoding error: \(error?.localizedDescription)")
                completion(nil, error)
                return
            }
            completion(location.coordinate, nil)
        }
    }
    
    func getGeoPoint(searchQuery: String, completion: @escaping (GeoPoint) -> Void) {
        getCoordinates(from: searchQuery) { (coordinates, error) in
            if let error = error {
                print("Error getting coordinates: \(error.localizedDescription)")
                completion(GeoPoint(latitude: 0, longitude: 0))
            } else if let coordinates = coordinates {
                completion(GeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
            }
        }
    }
    
    func getLocation(location: GeoPoint, completion: @escaping (String) -> Void) {
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
    
    // Function to populate friend recommendations for the user
    func fetchRecs(friends: [User], user: User, recs: [User], completion: @escaping ([User]) -> Void) {
        var scores: [(User, Double)] = []
        for u in dbDocuments.users {
            
            if !friends.contains(where: { friend in
                return friend.id == u.id
            }) {
                if u.id != user.id {
                    let score = self.getSimilarityScore(u, user)
                    scores.append((u, score))
                }
            }
          
        }
        
        completion(scores.sorted(by: { $0.1 > $1.1 }).prefix(5).map { $0.0 })
    }
    
    func getSimilarityScore(_ u: User, _ user: User) -> Double {
        let schoolSimilarity = self.calculateSchoolSimilarity(u, user)
        let hometownSimilarity = self.calculateHometownSimilarity(u, user)
        let currentCitySimilarity = self.calculateCurrentCitySimilarity(u, user)
        
        return (schoolSimilarity + hometownSimilarity + currentCitySimilarity) / 3
    }
    
    func calculateSchoolSimilarity(_ user1: User, _ user2: User) -> Double {
        var commonSchools = Set(user1.schools.values).intersection(Set(user2.schools.values))
        commonSchools.remove("")
        return Double(commonSchools.count) / Double(max(user1.schools.count, user2.schools.count))
    }
    
    func calculateHometownSimilarity(_ user1: User, _ user2: User) -> Double{
        let maxDistance = 5000000.0 // 5,000km
        
        let location1 = CLLocation(latitude: user1.hometown_geo.latitude, longitude: user1.hometown_geo.longitude)
        let location2 = CLLocation(latitude: user2.hometown_geo.latitude, longitude: user2.hometown_geo.longitude)
        
        let distance = location1.distance(from: location2)
        if distance > maxDistance{
            return 0
        }else{
            return 1 - (distance / maxDistance)
        }
        
    }
    
    func calculateCurrentCitySimilarity(_ user1: User, _ user2: User) -> Double {
        if user1.current_city == "" || user1.current_city == ""{
            return 0
        }
        return user1.current_city == user2.current_city ? 1.0 : 0.0
    }
}

class ESchoolViewModel: LocationViewModel {
    override func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      searchResults = completer.results.filter { $0.title.lowercased().contains("school") || $0.title.lowercased().contains("university") || $0.title.lowercased().contains("college") || $0.title.lowercased().contains("academy") || $0.title.lowercased().contains("institute")}

    }
}

class MSchoolViewModel: LocationViewModel {
    override func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      searchResults = completer.results.filter { $0.title.lowercased().contains("school") || $0.title.lowercased().contains("university") || $0.title.lowercased().contains("college") || $0.title.lowercased().contains("academy") || $0.title.lowercased().contains("institute")}

    }
}

class HSchoolViewModel: LocationViewModel {
    override func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      searchResults = completer.results.filter { $0.title.lowercased().contains("school") || $0.title.lowercased().contains("university") || $0.title.lowercased().contains("college") || $0.title.lowercased().contains("academy") || $0.title.lowercased().contains("institute")}

    }
}

class UniViewModel: LocationViewModel {
    override func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      searchResults = completer.results.filter { $0.title.lowercased().contains("school") || $0.title.lowercased().contains("university") || $0.title.lowercased().contains("college") || $0.title.lowercased().contains("academy") || $0.title.lowercased().contains("institute")}

    }
}
