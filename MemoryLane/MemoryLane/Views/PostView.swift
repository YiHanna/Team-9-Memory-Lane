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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
    var body: some View {
      ScrollView {
        VStack {
          ZStack {
            if let photoUrl = post.photo{
              AsyncImage(url: URL(string: photoUrl)) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .cornerRadius(10)
                  .padding()
              } placeholder: {
                Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
              }
              .edgesIgnoringSafeArea(.all)
            } else {
              Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                .edgesIgnoringSafeArea(.all)
            }
            VStack {
              HStack {
                if let name = userName {
                  Text(name).foregroundColor(Color.white)
                    .font(.system(size: 15))
                }
                Spacer()
              }
              .padding(.top)
              Spacer()
              HStack{
                VStack (alignment: .leading){
                  Text(post.getDate()).foregroundColor(Color.white)
                    .font(.system(size: 15))
                  if let loc = location {
                    Text(loc).foregroundColor(Color.white)
                  }
                  Text(post.description).foregroundColor(Color.white)
                    .font(.system(size: 15))
                }
                
                Spacer()
                
                VStack {
                  if let liked = userLiked{
                    if liked{
                      Button(action: {
                          dbDocuments.unlikePost(post_id: post.id!)
                          checkUserLikes()
                      }) {
                        Image(systemName: "heart.fill")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 20, height: 20)
                          .foregroundColor(.white)
                          .background(.clear)
                      }
                    } else {
                      Button(action: {
                          dbDocuments.likePost(post_id: post.id!)
                          checkUserLikes()
                      }) {
                        Image(systemName: "heart")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 20, height: 20)
                          .foregroundColor(.white)
                          .background(.clear)
                      }
                    }
                  }
                  
                  Image("message")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                  
                } // VStack
                .padding(.bottom)
              } // HStack
            } // VStack
            .frame(width: 330)
            .padding()
          }
          
          HStack{
            TextField("Leave a comment", text: $comment)
              .font(.system(size: 15))
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
              post.comment(text: comment)
            }) {
              Image(systemName: "paperplane")
                .foregroundColor(.brown)
            }
          }
          .frame(width: 330)
          
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
      .navigationBarBackButtonHidden(true)
      .navigationBarItems(
        leading: Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "chevron.backward")
            .foregroundColor(Color.brown)
        }
      )
    }
  
    private func fetchUserName() {
        userName = dbDocuments.getUserName(user_id: post.user_id.documentID)
    }
    
    private func checkUserLikes(){
        if let id = post.id{
            userLiked = dbDocuments.checkUserLikes(id: id)
        }
    }
  
    private func getComments() {
        comments = dbDocuments.getPostComments(post_id: post.id)
        comments.sort()
    }
}
