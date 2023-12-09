//
//  FriendsView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI
import Firebase

struct FriendsView: View {
    @State private var selectedTab = 0
    var user: User?
    var body: some View {
      
      if let u = user {
        VStack {
            // Top Menu for Tab Selection
            Picker(selection: $selectedTab, label: Text("")) {
              Text("Friends").tag(0)
              Text("Recommendations").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Tab Content
            TabView(selection: $selectedTab) {
                FriendsListView(user: u, dbDocuments: dbDocuments)
                  .tag(0)
                RecommendationsView(user: u, dbDocuments: dbDocuments)
                  .tag(1)
            }
        }
      } else {
        LoginView()
      }
    }
}

struct FriendsListView: View {
    var user: User
    @ObservedObject var dbDocuments: DBDocuments

    var body: some View {
        VStack {
            if dbDocuments.friends.isEmpty {
                Text("No friends")
            } else {
                List(dbDocuments.friends) { friend in
                  NavigationLink(destination: OtherUserProfileView(otherUser: friend, currUser: user).environmentObject(dbDocuments)) {
                        Text(friend.name)
                    }
                }
            }
        }
    }
}

struct RecommendationsView: View {
    @ObservedObject var viewModel = LocationViewModel()
    var user: User
    @ObservedObject var dbDocuments: DBDocuments
    @State private var recs: [User] = []

    var body: some View {
        VStack {
            if recs.isEmpty {
                Text("No recommendations")
            } else {
                List(recs) { rec in
                  NavigationLink(destination: OtherUserProfileView(otherUser: rec, currUser: user).environmentObject(dbDocuments)) {
                        Text(rec.name)
//                        Text("similarity score: " + String((viewModel.getSimilarityScore(user, rec) * 100).rounded() / 100)).font(.caption)
                          .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchRecs(friends: dbDocuments.friends, user: user, recs: recs) { fetchedRecs in
                recs = fetchedRecs
            }
        }
    }
}
