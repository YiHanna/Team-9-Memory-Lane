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
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                completion(nil, error)
                return
            }
            
            completion(location.coordinate, nil)
        }
    }
    
    func getGeoPoint(completion: @escaping (GeoPoint) -> Void) {
        getCoordinates(from: searchQuery) { (coordinates, error) in
            if let error = error {
                print("Error getting coordinates: \(error.localizedDescription)")
                completion(GeoPoint(latitude: 0, longitude: 0))
            } else if let coordinates = coordinates {
                completion(GeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
            }
        }
    }
    
    // Function to populate friend recommendations for the user
    // TODO: Currently, this is a basic level of recommendation (any user on the app which is not me or my friend). In the next iteration, the recommendation algorithm should be more advanced (i.e. users who went to the same school as me)
    func fetchRecs(friends: [User], user: User, recs: [User], completion: @escaping ([User]) -> Void) {
        var scores: [(User, Double)] = []
        dbDocuments.getAllUsers() { users in
            for u in users {
                
                if !friends.contains(where: { friend in
                    return friend.id == u.id
                }) {
                    if u.id != user.id {
                        scores.append((u, self.getSimilarityScore(u, user)))
                    }
                }
              
            }
            
            completion(scores.sorted(by: { $0.1 > $1.1 }).prefix(5).map { $0.0 })
        }
    }
    
    func getSimilarityScore(_ u: User, _ user: User) -> Double {
        let schoolSimilarity = self.calculateSchoolSimilarity(u, user)
        let hometownSimilarity = self.calculateHometownSimilarity(u, user)
        let currentCitySimilarity = self.calculateCurrentCitySimilarity(u, user)
        
        return (schoolSimilarity + hometownSimilarity + currentCitySimilarity) / 3
    }
    
    func calculateSchoolSimilarity(_ user1: User, _ user2: User) -> Double {
        let commonSchools = Set(user1.schools.values).intersection(Set(user2.schools.values))
        return Double(commonSchools.count) / Double(max(user1.schools.count, user2.schools.count))
    }
    
    func calculateHometownSimilarity(_ user1: User, _ user2: User) -> Double {
        return user1.hometown == user2.hometown ? 1.0 : 0.0
    }
    
    func calculateCurrentCitySimilarity(_ user1: User, _ user2: User) -> Double {
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
