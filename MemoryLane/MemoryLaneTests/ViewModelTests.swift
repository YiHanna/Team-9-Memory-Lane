//
//  ViewModelTests.swift
//  MemoryLaneTests
//
//  Created by Cindy Chen on 12/11/23.
//

import XCTest
@testable import MemoryLane
import FirebaseFirestore

final class ViewModelTests: XCTestCase {
    
    let viewModel = LocationViewModel()
    let user1 = User(email: "user1@gmail.com", 
                     name: "John",
                     username: "john123",
                     schools: [
                        "elementary_school": "Pittsburgh Elementary School",
                        "middle_school": "Pittsburgh Middle School",
                        "high_school": "AAA High School",
                        "university": "Carnegie Mellon University"
                      ],
                     hometown: "Pittsburgh, PA", 
                     hometown_geo: GeoPoint(latitude: 40.440624, longitude: -79.995888), 
                     current_city: "Pittsburgh, PA",
                     friends: [], posts_liked: [])
    let user2 = User(email: "user2@gmail.com",
                     name: "Alice",
                     username: "aliceeee",
                     schools: [
                        "elementary_school": "San Francisco Elementary School",
                        "middle_school": "Oakland Middle School",
                        "high_school": "AAA High School",
                        "university": "Carnegie Mellon University"
                      ],
                     hometown: "San Francisco, CA",
                     hometown_geo: GeoPoint(latitude: 37.773972, longitude: -122.431297),
                     current_city: "Pittsburgh, PA",
                     friends: [], posts_liked: [])
    
    let user3 = User(email: "user3@gmail.com",
                     name: "Bob",
                     username: "bobb",
                     schools: [
                        "elementary_school": "",
                        "middle_school": "",
                        "high_school": "",
                        "university": "Carnegie Mellon University"
                      ],
                     hometown: "San Francisco, CA",
                     hometown_geo: GeoPoint(latitude: 37.773972, longitude: -122.431297),
                     current_city: "Pittsburgh, PA",
                     friends: [], posts_liked: [])
    
    let user4 = User(email: "user4@gmail.com",
                     name: "User 4",
                     username: "user4",
                     schools: [
                        "elementary_school": "",
                        "middle_school": "",
                        "high_school": "",
                        "university": ""
                      ],
                     hometown: "",
                     hometown_geo: GeoPoint(latitude: 0, longitude: 0),
                     current_city: "New York City, NY",
                     friends: [], posts_liked: [])

    func testLocation() throws{
        let expectation = XCTestExpectation(description: "getGeoPoint completion")

        let searchQuery = "Pittsburgh, PA"
        viewModel.getGeoPoint(searchQuery: searchQuery){ result in
            XCTAssert(result.latitude.rounded() == 40)
            XCTAssert(result.longitude.rounded() == -80)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testBadLocation() throws{
        let expectation = XCTestExpectation(description: "getGeoPoint completion")

        let searchQuery = ""
        viewModel.getGeoPoint(searchQuery: searchQuery){ result in
            XCTAssert(result.latitude == 0)
            XCTAssert(result.longitude == 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCalculateSchoolSimilarity() throws{
        let result = viewModel.calculateSchoolSimilarity(user1, user2)
        XCTAssert(result == 0.5)
    }
    
    func testBadCalculateSchoolSimilarity() throws{
        let result = viewModel.calculateSchoolSimilarity(user3, user4)
        XCTAssert(result == 0)
    }
    
    func testCalculateHometownSimilarity() throws{
        let result = viewModel.calculateHometownSimilarity(user1, user2)
        XCTAssert((result * 100).rounded()/100 == 0.27)
    }
    
    func testBadCalculateHometownSimilarity() throws{
        let result = viewModel.calculateHometownSimilarity(user3, user4)
        XCTAssert(result == 0)
    }
    
    func testCalculateCurrentCitySimilarity() throws{
        let result = viewModel.calculateCurrentCitySimilarity(user1, user2)
        XCTAssert(result == 1)
    }
    
    func testBadCalculateCurrentCitySimilarity() throws{
        let result = viewModel.calculateCurrentCitySimilarity(user1, user4)
        XCTAssert(result == 0)
    }
    
    func testGetSimilarityScore() throws{
        let result = viewModel.getSimilarityScore(user1, user2)
        print(result)
        XCTAssert((result * 100).rounded()/100 == 0.59)
    }
}


