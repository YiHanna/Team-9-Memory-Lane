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
    @State var postsDict: [Int:[Post]] = [:]
    @State private var isFriend: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
    var body: some View {
      VStack {
        ZStack {
          Color.beige.edgesIgnoringSafeArea(.all)
          
          List {
            Section {
              VStack {
                if otherUser.photo == nil {
                  Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                  AsyncImage(url: URL(string: otherUser.photo!)) { image in
                    image.resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 100, height: 100)
                      .clipShape(Circle())
                  } placeholder: {
                    Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                  }
                }
                
                Text(otherUser.name)
                  .font(.system(size: 17))
                  .bold()
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color.brown)
                  .padding(.bottom, 2)
                
                Text(otherUser.username)
                  .font(.system(size: 15))
                  .foregroundColor(Color.taupe)
                
                if isFriend {
                  Button(action: {
                    removeFriend()
                  }) {
                    Text("Friends")
                      .font(.system(size: 15))
                      .padding(15)
                      .background(Color.darkBeige)
                      .foregroundColor(Color.black)
                      .cornerRadius(10)
                      .padding(.bottom, 10)
                  }
                } else {
                  Button(action: {
                    addFriend()
                  }) {
                    Text("Add Friend")
                      .font(.system(size: 15))
                      .padding(15)
                      .background(Color.taupe)
                      .foregroundColor(Color.white)
                      .cornerRadius(10)
                      .padding(.bottom, 10)
                  }
                }
                
                ZStack {
                  RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 360, height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                  
                  VStack {
                    Text("Info")
                      .font(.system(size: 15))
                      .foregroundColor(Color.brown)
                      .frame(width: 330, alignment: .leading)
                      .padding(.bottom, 3)
                    
                    HStack {
                      Text("Hometown")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      Text(otherUser.hometown)
                        .font(.system(size: 15))
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 3)
                    
                    HStack {
                      Text("Elementary School")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      if let eleschool = otherUser.schools["elementary_school"] {
                        Text(eleschool)
                          .font(.system(size: 15))
                      }
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 3)
                    
                    HStack {
                      Text("Middle School")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      if let mschool = otherUser.schools["middle_school"] {
                        Text(mschool)
                          .font(.system(size: 15))
                      }
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 3)
                    
                    HStack {
                      Text("High School")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      if let hschool = otherUser.schools["high_school"] {
                        Text(hschool)
                          .font(.system(size: 15))
                      }
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 3)
                    
                    HStack {
                      Text("University")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      if let uni = otherUser.schools["university"] {
                        Text(uni)
                          .font(.system(size: 15))
                      }
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 3)
                    
                    HStack {
                      Text("Current City")
                        .font(.system(size: 15))
                        .bold()
                      Spacer()
                      Text(otherUser.current_city)
                        .font(.system(size: 15))
                    }
                    .padding([.leading, .trailing], 30)
                  } // VStack
                } // ZStack
              } // Section
              .listRowBackground(Color.beige)
              .listRowSeparator(.hidden)
              
              Section {
                Text("Memory Lane")
                  .font(.system(size: 15))
                  .foregroundColor(Color.brown)
                  .frame(width: 360, alignment: .leading)
                  .background(Color.beige)
                  .padding(.top, 15)

                if posts.isEmpty {
                  Text("Nothing to see here.")
                    .font(.system(size: 15))
                    .foregroundColor(Color.taupe)
                    .padding(.top, 5)
                } else {
                    ForEach(Array(postsDict.sorted(by: { $0.key > $1.key })), id: \.key) { year, postsInYear in
                            Text(String(year))
                              .font(.system(size: 20))
                              .bold()
                              .foregroundColor(Color.brown)
                              .frame(width: 360, alignment: .leading)
                              .padding(.top, 5)
                            
                            ForEach(postsInYear, id: \.id) { post in
                                PostRowView(post: post)
                                .frame(width: 360, height: 480)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                                .listRowBackground(Color.beige)
                                .listRowSeparator(.hidden)
                            }
                    }
                    
                    Text("End of memory lane.")
                    .font(.system(size: 15))
                    .foregroundColor(Color.taupe)
                    .padding(.top, 5)
                }
              } // Section
              .listRowBackground(Color.beige)
              .listRowSeparator(.hidden)
            } // VStack
          } // List
          .listStyle(PlainListStyle())
          .listRowBackground(Color.beige)
          .listRowSeparator(.hidden)
        } // ZStack
      } // NavigationView
      .navigationBarBackButtonHidden(true)
      .navigationBarItems(
        leading: Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "chevron.backward")
            .foregroundColor(Color.brown)
        }
      )
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
      posts.sort()
      print("user posts fetched")
      print(posts.count)
      postsDict = Dictionary(grouping: posts, by: {$0.getYear()})
      for (year, postsByYear) in postsDict {
          postsDict[year] = postsByYear.sorted(by: { $0.date.dateValue() > $1.date.dateValue() })
      }
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
