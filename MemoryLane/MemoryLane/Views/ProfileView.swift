//
//  ProfileView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        if let u = dbDocuments.currUser {
          UserProfileView(dbDocuments: dbDocuments).environmentObject(dbDocuments)
        } else {
          LoginView().environmentObject(dbDocuments)
        }
    }
}

struct UserProfileView: View {
    @ObservedObject var dbDocuments: DBDocuments
    @State var posts: [Post] = []
    @State var postsDict: [Int:[Post]] = [:]
  
    var body: some View {
        NavigationView {
            ZStack {
                Color.beige.edgesIgnoringSafeArea(.all)
                List{
                    Section{
                        VStack {
                            if let photoUrl = dbDocuments.currUser!.photo{
                                AsyncImage(url: URL(string: photoUrl)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                } placeholder: {
                                    Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                                }
                                .edgesIgnoringSafeArea(.all)
                            } else {
                                Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            Text(dbDocuments.currUser!.name)
                                .font(.system(size: 17))
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.brown)
                                .padding(.bottom, 2)
                            
                            Text(dbDocuments.currUser!.username)
                                .font(.system(size: 15))
                                .foregroundColor(Color.taupe)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 360, height: 220)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                                
                                VStack {
                                HStack {
                                  Text("My Info")
                                  .font(.system(size: 15))
                                  .foregroundColor(Color.brown)
                                  
                                  Spacer()
                                    
                                  NavigationLink(destination: ProfileEditView(user: dbDocuments.currUser!)) {
                                    Text("Edit")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.taupe)
                                  }
                                  .environmentObject(dbDocuments)
                                  .aspectRatio(contentMode: .fit)
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("Hometown")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    Text(dbDocuments.currUser!.hometown)
                                    .font(.system(size: 15))
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("Elementary School")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    if let eleschool = dbDocuments.currUser!.schools["elementary_school"] {
                                      Text(eleschool)
                                      .font(.system(size: 15))
                                    }
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("Middle School")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    if let mschool = dbDocuments.currUser!.schools["middle_school"] {
                                      Text(mschool)
                                      .font(.system(size: 15))
                                    }
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("High School")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    if let hschool = dbDocuments.currUser!.schools["high_school"] {
                                    Text(hschool)
                                    .font(.system(size: 15))
                                    }
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("University")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    if let uni = dbDocuments.currUser!.schools["university"] {
                                      Text(uni)
                                      .font(.system(size: 15))
                                    }
                                }
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 3)
                                
                                HStack {
                                    Text("Current City")
                                    .font(.system(size: 15))
                                    .bold()
                                    Spacer()
                                    Text(dbDocuments.currUser!.current_city)
                                    .font(.system(size: 15))
                                }
                                .padding([.leading, .trailing], 15)
                                }
                            }
                            
                        }.background(Color.beige)
                    }.listRowBackground(Color.beige)
                     .listRowSeparator(.hidden)
                    
                    Section(header: Text("My Memory Lane")
                        .font(.system(size: 15))
                        .foregroundColor(Color.brown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.beige)
                        .padding(.trailing, 15)){
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
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                      .padding(.top, 5)
                                      .listRowBackground(Color.beige)
                                      .listRowSeparator(.hidden)
                                    
                                    ForEach(postsInYear, id: \.id) { post in
                                        PostRowView(post: post).listRowBackground(Color.beige)
                                        .listRowSeparator(.hidden)
                                    }
                                    .onDelete(perform: deletePost)
                            }
                            
                            Text("End of memory lane. Add memories for more!")
                            .font(.system(size: 15))
                            .foregroundColor(Color.taupe)
                            .padding(.top, 5)
                            .listRowBackground(Color.beige)
                            .listRowSeparator(.hidden)
                            
                        }
                    }.background(Color.beige)
                    
                    
                }.listStyle(PlainListStyle()).listRowBackground(Color.beige)
                    .listRowSeparator(.hidden)
          
                
            }.onAppear{
                getPosts()
            }
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
        posts = dbDocuments.getUserPosts(user_id: dbDocuments.currUser!.id)
        posts.sort()
        print("user posts fetched")
        print(posts.count)
        postsDict = Dictionary(grouping: posts, by: {$0.getYear()})
        for (year, postsByYear) in postsDict {
            postsDict[year] = postsByYear.sorted(by: { $0.date.dateValue() > $1.date.dateValue() })
        }
    }
}
