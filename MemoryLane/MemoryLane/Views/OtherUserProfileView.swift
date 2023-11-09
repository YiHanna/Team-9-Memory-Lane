//
//  OtherUserProfileView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var otherUser: User
    var currUser: User
    @State private var posts: [Post] = []
    @State private var isFriend: Bool = false
  
    var body: some View {
      VStack {
        Group {
          Text(otherUser.name)
            .font(.title)
          
          Text(otherUser.username)
            .font(.subheadline)
            .foregroundColor(.gray)
          
          if isFriend {
            Button(action: {
              removeFriend()
            }) {
              Text("Friends")
                .padding()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
          } else {
            Button(action: {
              addFriend()
            }) {
              Text("Add Friend")
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
          }
        }
        
        Group {
          HStack {
            Text("Hometown: ")
            Spacer()
            Text(otherUser.hometown)
          }
          
          HStack {
            Text("Elementary School: ")
            Spacer()
            if let eleschool = otherUser.schools["elementary_school"] {
              Text(eleschool)
            }
          }
          
          HStack {
            Text("Middle School: ")
            Spacer()
            if let mschool = otherUser.schools["middle_school"] {
              Text(mschool)
            }
          }
          
          HStack {
            Text("High School: ")
            Spacer()
            if let hschool = otherUser.schools["high_school"] {
              Text(hschool)
            }
          }
          
          HStack {
            Text("University School: ")
            Spacer()
            if let uni = otherUser.schools["university"] {
              Text(uni)
            }
          }
          
          HStack {
            Text("Current City: ")
            Spacer()
            Text(otherUser.current_city)
          }
          .padding(.bottom)
        }
        
        Group {
          Text("Timeline")
          Spacer()
          List {
            ForEach(posts) { post in
              PostRowView(post: post)
            }
          }
        }
      }
     .padding()
     .onAppear{
       getPosts()
       checkFriendStatus()
     }
    }
  
  private func getPosts() {
    dbDocuments.getUserPosts(user_id: otherUser.id){ fetchedPosts in
      if let p = fetchedPosts {
        posts = p
      } else {
        print("failed to fetch user posts")
      }
    }
  }
  
  private func addFriend() {
    dbDocuments.addFriend(user: currUser, friend: otherUser) { res in
      if res {
        isFriend = true
      }
    }
  }
  
  private func removeFriend() {
    dbDocuments.removeFriend(user: currUser, friend: otherUser) { res in
      if res {
        isFriend = false
      }
    }
  }
  
  private func checkFriendStatus() {
    dbDocuments.checkFriendStatus(user: currUser, possibleFriend: otherUser) { res in
      isFriend = res
    }
  }
  
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
