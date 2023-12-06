//
//  PostView.swift
//  MemoryLane
//
//  Created by Hanna Luo on 12/6/23.
//

import Foundation
import SwiftUI

struct PostView: View {
    @State private var image: UIImage? = nil
    
    var post : Post
    @State private var userName: String?
    @State private var location: String?
    @State private var userLiked: Bool?
  
    @State var comment = ""
  @State var comments:[Comment] = []
  
    var body: some View {
      ScrollView{
        VStack{
          ZStack{
            if let photoUrl = post.photo{
              AsyncImage(url: URL(string: photoUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
              } placeholder: {
                Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
              }
              .edgesIgnoringSafeArea(.all)
            } else{
              Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                .edgesIgnoringSafeArea(.all)
            }
            VStack {
              HStack {
                if let name = userName {
                  Text(name).foregroundColor(Color.white)
                }
                Spacer()
              }
              Spacer()
              HStack{
                VStack (alignment: .leading){
                  Text(post.getDate()).foregroundColor(Color.white)
                  if let loc = location {
                    Text(loc).foregroundColor(Color.white)
                  }
                  Text(post.description).foregroundColor(Color.white)
                }
                VStack{
                  if let liked = userLiked{
                    if liked{
                      Button(action: {
                        dbDocuments.unlikePost(post: post)
                        checkUserLikes()
                      }) {
                        Image(systemName: "heart.fill").foregroundColor(.white)
                      }
                    }else{
                      Button(action: {
                        dbDocuments.likePost(post: post)
                        checkUserLikes()
                      }) {
                        Image(systemName: "heart").foregroundColor(.white)
                      }
                    }
                  }
                  
                }.padding()
              }
            }.padding()
          }
          HStack{
            TextField("Enter a comment", text: $comment)
              .font(.system(size: 14))
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
              post.comment(text: comment)
            }) {
              Image(systemName: "paperplane")
            }
          }
          
          //comments
          ForEach(comments) { comment in
            CommentRowView(comment: comment)
          }
        }
      }.onAppear {
        fetchUserName()
        checkUserLikes()
        getComments()
        post.getLocation { locationString in
          location = locationString
        }
      }
    }
  
    private func fetchUserName() {
      dbDocuments.getUserName(user_ref: post.user_id) { (fetchedName) in
          userName = fetchedName
      }
    }
    
    private func checkUserLikes(){
        if let id = post.id{
            dbDocuments.checkUserLikes(id: id){res in
                userLiked = res
            }
        }
    }
  
    private func getComments() {
      dbDocuments.getPostComments(post_id: post.id){ (fetchedComments) in
        if let c = fetchedComments {
          comments = c
          comments.sort()
          print("user posts fetched")
          print(comments.count)
        } else {
          print("failed to fetch user posts")
        }
      }
    }
}
