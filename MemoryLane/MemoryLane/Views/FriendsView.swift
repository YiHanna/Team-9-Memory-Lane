//
//  FriendsView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI
import Firebase

// TODO: get currently signed-in user instead of dbDocuments.users[0]

struct FriendsView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    @State private var selectedTab = 0
    var body: some View {
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
              FriendsListView(user: dbDocuments.users[0])
                  .tag(0)
              RecommendationsView(user: dbDocuments.users[0])
                  .tag(1)
            }
        }
    }
}

struct FriendsListView: View {
    var user: User
    @State private var friends: [User] = []

    var body: some View {
        VStack {
            if friends.isEmpty {
                Text("No friends")
            } else {
                List(friends, id: \.id) { friend in
                    NavigationLink(destination: UserDetailView(user: friend)) {
                        Text(friend.name)
                    }
                }
            }
        }
        .onAppear {
            fetchFriends() { fetchedFriends  in
              friends = fetchedFriends
            }
        }
    }

    // Function to fetch the user's friends
    func fetchFriends(completion: @escaping ([User]) -> Void) {
        // Create a dispatch group to wait for all friend fetches to complete
        let group = DispatchGroup()

        var friends: [User] = []

        for f in user.friends {
            group.enter()
            dbDocuments.getUserByRef(user_ref: f) { friend in
                if let friend = friend {
                    friends.append(friend)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(friends)
        }
    }
}

struct RecommendationsView: View {
    var user: User
    @State private var recs: [User] = []

    var body: some View {
        VStack {
            if recs.isEmpty {
                Text("No recommendations")
            } else {
                List(recs, id: \.id) { rec in
                    NavigationLink(destination: UserDetailView(user: rec)) {
                        Text(rec.name)
                    }
                }
            }
        }
        .onAppear {
            fetchRecs() { fetchedRecs  in
              recs = fetchedRecs
            }
        }
    }
    
    // Function to fetch friend recommendations for the user
    func fetchRecs(completion: @escaping ([User]) -> Void) {
        // Create a dispatch group to wait for all friend fetches to complete
        let group = DispatchGroup()

        var friends: [User] = []

        // TODO: Fix this to find all users who go to same school or hometown
        for f in user.friends {
            group.enter()
            dbDocuments.getUserByRef(user_ref: f) { friend in
                if let friend = friend {
                    friends.append(friend)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(friends)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
