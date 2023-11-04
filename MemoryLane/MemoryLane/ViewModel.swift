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


class ViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var searchQuery: String = ""
    @Published var showLocationResults: Bool = true
    
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
}
