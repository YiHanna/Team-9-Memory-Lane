//
//  ViewModel.swift
//  MapKitPlayground
//
//  Created by Hanna Luo on 10/25/23.
//

import Foundation
import SwiftUI
import MapKit
import Combine

class ViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var searchQuery: String = ""
    
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
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
