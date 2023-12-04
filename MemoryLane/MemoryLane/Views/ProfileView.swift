//
//  ProfileView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var user: User?
    var body: some View {
      if let u = user {
        UserProfileView(user: u).environmentObject(dbDocuments)
      } else {
        LoginView().environmentObject(dbDocuments)
      }
    }
}

struct UserProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    @State var user: User
    @State var posts: [Post] = []
    var body: some View {
      NavigationView{
        VStack {
          //         profileImage
          //             .resizable()
          //             .aspectRatio(contentMode: .fit)
          //             .frame(width: 100, height: 100)
          //             .clipShape(Circle())
          //             .padding()
          
          Text(user.name)
            .font(.title)
          
          Text(user.username)
            .font(.subheadline)
            .foregroundColor(.gray)
          HStack {
            Text("Hometown: ")
            Spacer()
            Text(user.hometown)
          }
          
          HStack {
            Text("Elementary School: ")
            Spacer()
            if let eleschool = user.schools["elementary_school"] {
              Text(eleschool)
            }
          }
          
          HStack {
            Text("Middle School: ")
            Spacer()
            if let mschool = user.schools["middle_school"] {
              Text(mschool)
            }
          }
          
          HStack {
            Text("High School: ")
            Spacer()
            if let hschool = user.schools["high_school"] {
              Text(hschool)
            }
          }
          
          HStack {
            Text("University School: ")
            Spacer()
            if let uni = user.schools["university"] {
              Text(uni)
            }
          }
          
          HStack {
            Text("Current City: ")
            Spacer()
            Text(user.current_city)
          }
          .padding(.bottom)
          
          Text("Timeline")
          
          List {
            ForEach(posts) { post in
              PostRowView(post: post)
            }.onDelete(perform: deletePost)
          }
        }
        .navigationBarTitle("Profile")
        .navigationBarItems(trailing: NavigationLink(destination: ProfileEditView(user: user)) {
          Text("Edit Profile")}.environmentObject(dbDocuments))
        .padding()
        .onAppear{
          getUser()
          getPosts()
        }
      }
    }
  private func getUser() {
    let us = dbDocuments.getUserByUsername(username: user.username)
    if let u = us {
      user = u
    } else {
      LoginView()
    }
  }
    
    private func deletePost(at offsets: IndexSet){
        let postsToDelete = offsets.map { posts[$0] }
        
        for post in postsToDelete {
            print("Deleting post: \(post)")
            
            dbDocuments.removePostFromDB(post)
        }
        
        posts.remove(atOffsets: offsets)
    }
    
    
  private func getPosts() {
    dbDocuments.getUserPosts(user_id: user.id){ (fetchedPosts) in
      if let p = fetchedPosts {
        posts = p
        posts.sort()
        print("user posts fetched")
        print(posts.count)
      } else {
        print("failed to fetch user posts")
      }
    }
  }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: nil)
//    }
//}
