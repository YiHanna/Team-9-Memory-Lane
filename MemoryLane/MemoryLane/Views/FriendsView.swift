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
        ZStack {
          Color.beige.edgesIgnoringSafeArea(.all)
          
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
              List {
                ForEach(dbDocuments.friends) { friend in
                  NavigationLink(destination: OtherUserProfileView(otherUser: friend, currUser: user).environmentObject(dbDocuments)) {
                    HStack {
                      if friend.photo == nil {
                        Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                      } else {
                        AsyncImage(url: URL(string: friend.photo!)) { image in
                          image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        } placeholder: {
                          Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                        }
                      }
                      Text(friend.name)
                        .font(.system(size: 15))
                      
//                      Spacer()
//
//                      Button(action: {
//                        dbDocuments.addFriend(friend: friend, completion: () -> Void )
//                      }) {
//                        Text("Friends")
//                          .font(.system(size: 15))
//                          .padding(10)
//                          .background(Color.gray)
//                          .foregroundColor(Color.white)
//                          .cornerRadius(10)
//                      }
                    }
                    .padding(.vertical, 3)
                  }
                }
              }
              .background(Color.beige)
              .scrollContentBackground(.hidden)
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
              List{
                ForEach (recs) { rec in
                  NavigationLink(destination: OtherUserProfileView(otherUser: rec, currUser: user).environmentObject(dbDocuments)) {
                    HStack {
                      if rec.photo == nil {
                        Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                      } else {
                        AsyncImage(url: URL(string: rec.photo!)) { image in
                          image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        } placeholder: {
                          Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                        }
                      }
                      Text(rec.name)
                        .font(.system(size: 15))
                      
//                      Spacer()
//                      
//                      Button(action: {
//                      }) {
//                        Text("Add Friend")
//                          .font(.system(size: 15))
//                          .padding(10)
//                          .background(Color.gray)
//                          .foregroundColor(Color.white)
//                          .cornerRadius(10)
//                      }
                      
                      // Text("similarity score: " + String((viewModel.getSimilarityScore(user, rec) * 100).rounded() / 100)).font(.caption)
                    }
                    .padding(.vertical, 3)
                  }
                }
              }
              .background(Color.beige)
              .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            viewModel.fetchRecs(friends: dbDocuments.friends, user: user, recs: recs) { fetchedRecs in
                recs = fetchedRecs
            }
        }
    }
}
