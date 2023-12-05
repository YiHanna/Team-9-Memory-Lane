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
    @State var postsDict: [Int:[Post]] = [:]
  
    var body: some View {
      NavigationView {
        ZStack {
          Color.beige.edgesIgnoringSafeArea(.all)
          
          ScrollView {
            VStack {
              //         profileImage
              //             .resizable()
              //             .aspectRatio(contentMode: .fit)
              //             .frame(width: 100, height: 100)
              //             .clipShape(Circle())
              //             .padding()
              
              Text(user.name)
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(Color.brown)
                .frame(width: 184, height: 25, alignment: .top)
              
              Text(user.username)
                .font(.system(size: 14))
                .foregroundColor(Color.taupe)
              
              ZStack {
                RoundedRectangle(cornerRadius: 10)
                  .fill(Color.white)
                  .frame(width: 360, height: 210)
                  .cornerRadius(10)
                  .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                
                VStack {
                  HStack {
                    Text("My Info")
                      .font(.system(size: 14))
                      .foregroundColor(Color.brown)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileEditView(user: user)) {
                      Text("Edit Profile")
                        .font(.system(size: 14))
                        .foregroundColor(Color.taupe)
                    }
                    .environmentObject(dbDocuments)
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("Hometown")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    Text(user.hometown)
                      .font(.system(size: 14))
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("Elementary School")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    if let eleschool = user.schools["elementary_school"] {
                      Text(eleschool)
                        .font(.system(size: 14))
                    }
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("Middle School")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    if let mschool = user.schools["middle_school"] {
                      Text(mschool)
                        .font(.system(size: 14))
                    }
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("High School")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    if let hschool = user.schools["high_school"] {
                      Text(hschool)
                        .font(.system(size: 14))
                    }
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("University")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    if let uni = user.schools["university"] {
                      Text(uni)
                        .font(.system(size: 14))
                    }
                  }
                  .padding([.leading, .trailing], 25)
                  .padding(.bottom, 3)
                  
                  HStack {
                    Text("Current City")
                      .bold()
                      .font(.system(size: 14))
                    Spacer()
                    Text(user.current_city)
                      .font(.system(size: 14))
                  }
                  .padding([.leading, .trailing], 25)
                }
              }
              
              Text("My Memory Lane")
                .font(.system(size: 14))
                .foregroundColor(Color.brown)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
                .padding([.leading, .trailing], 15)
              
              if posts.isEmpty {
                Text("Nothing to see here.")
                  .font(.system(size: 14))
                  .foregroundColor(Color.taupe)
                  .padding(.top, 5)
              } else {
                ForEach(Array(postsDict.sorted(by: { $0.key > $1.key })), id: \.key) { year, postsInYear in
                  VStack {
                    Text(String(year))
                      .font(.system(size: 20))
                      .bold()
                      .foregroundColor(Color.brown)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding(.top, 5)
                    
                    ForEach(postsInYear) { post in
                      PostRowView(post: post)
                        .frame(width: 360)
                    }.onDelete(perform: deletePost)
                  }
                  .padding(.horizontal, 15)
                }
                Text("End of memory lane. Add memories for more!")
                  .font(.system(size: 14))
                  .foregroundColor(Color.taupe)
                  .padding(.top, 5)
              }
            }
            .padding()
            .onAppear{
              getUser()
              getPosts()
            }
          }
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
        postsDict = Dictionary(grouping: posts, by: {$0.getYear()})
        for (year, postsByYear) in postsDict {
          postsDict[year] = postsByYear.sorted(by: { $0.date.dateValue() > $1.date.dateValue() })
        }
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
