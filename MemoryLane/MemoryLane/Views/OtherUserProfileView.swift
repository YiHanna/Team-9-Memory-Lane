//
//  OtherUserProfileView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    @State var otherUser: User
    @State var currUser: User
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
       // Must fetch from DB again as a work-around to complex list object binding
       getBothUsersFromDB() { _ in
         getPosts()
         checkFriendStatus()
       }
     }
    }
  
  private func getBothUsersFromDB(completion: @escaping (Bool) -> Void) {
    getUserFromDB(id: currUser.id!) { user in
      if let user = user {
        currUser = user
        getUserFromDB(id: otherUser.id!) { user2 in
          if let user2 = user2 {
            otherUser = user2
            completion(true)
          }
        }
      }
    }
    completion(false)
  }
  
  private func getUserFromDB(id: String, completion: @escaping (User?) -> Void) {
    let ref = dbDocuments.getUserById(id: id)
    if ref != nil {
      dbDocuments.getUserByRef(user_ref: ref!) { user in
        if let user = user {
          completion(user)
        }
      }
    }
    completion(nil)
  }
  
  private func getPosts() {
      posts = dbDocuments.getUserPosts(user_id: otherUser.id)
  }
  
  private func addFriend() {
    dbDocuments.addFriend(friend: otherUser) { res in
      if res {
        isFriend = true
      }
    }
  }
  
  private func removeFriend() {
    dbDocuments.removeFriend(friend: otherUser) { res in
      if res {
        isFriend = false
      }
    }
  }
  
  private func checkFriendStatus() {
      isFriend = dbDocuments.checkFriendStatus(user: currUser, possibleFriend: otherUser)
  }
  
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
