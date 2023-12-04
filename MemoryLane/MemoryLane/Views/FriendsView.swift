//
//  FriendsView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI
import Firebase

struct FriendsView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    @State private var selectedTab = 0
    var user: User?
    @State var friends: [User]
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
              FriendsListView(user: u, friends: $friends)
                  .environmentObject(dbDocuments)
                  .tag(0)
              RecommendationsView(user: u, friends: $friends)
                  .environmentObject(dbDocuments)
                  .tag(1)
            }
        }
        .onAppear {
          dbDocuments.getFriendsFromDB(user: u) { res in
            if let f = res {
              friends = f
            }
          }
        }
      } else {
        LoginView().environmentObject(dbDocuments)
      }
    }
}

struct FriendsListView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var user: User
    @Binding var friends: [User]

    var body: some View {
        VStack {
            if friends.isEmpty {
                Text("No friends")
            } else {
                List(friends) { friend in
                  NavigationLink(destination: OtherUserProfileView(otherUser: friend, currUser: user).environmentObject(dbDocuments)) {
                        Text(friend.name)
                    }
                }
            }
        }
        .onAppear {
          dbDocuments.getFriendsFromDB(user: user) { res in
            if let f = res {
              friends = f
            }
          }
        }
    }
}

struct RecommendationsView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    @ObservedObject var viewModel = ViewModel()
    var user: User
    @State private var recs: [User] = []
    @Binding var friends: [User]

    var body: some View {
        VStack {
            if recs.isEmpty {
                Text("No recommendations")
            } else {
                List(recs) { rec in
                  NavigationLink(destination: OtherUserProfileView(otherUser: rec, currUser: user).environmentObject(dbDocuments)) {
                        Text(rec.name)
                        Text("similarity score: " + String((viewModel.getSimilarityScore(user, rec) * 100).rounded() / 100)).font(.caption)
                          .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            friends = []
            dbDocuments.getFriendsFromDB(user: user) { res in
              if let f = res {
                friends = f
                viewModel.fetchRecs(friends: friends, user: user, recs: recs) { fetchedRecs in
                    recs = fetchedRecs
                }
              }
            }
        }
    }
    
    
}

// Function to fetch the user's friends
func fetchFriends(user: User, completion: @escaping ([User]) -> Void) {
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

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
