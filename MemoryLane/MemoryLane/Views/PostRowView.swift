//
//  PostRowView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct PostRowView: View {
    @State private var image: UIImage? = nil
    
    var post : Post
    @State private var userName: String?
    @State private var location: String?
    @State private var userLiked: Bool?
  
    var body: some View {
        ZStack{
            if let photoUrl = post.photo{
                AsyncImage(url: URL(string: photoUrl)) { image in
                  image.resizable().aspectRatio(0.75, contentMode: .fill)
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
                          .font(.system(size: 15))
                    }
                    Spacer()
                }
                .frame(width: 330)
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
                    Button(action: {
                      toggleLikePost(post: post)
                      checkUserLikes()
                    }) {
                      if let liked = userLiked {
                        Image(systemName: liked ? "heart.fill" : "heart")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 20, height: 20)
                          .foregroundColor(.white)
                          .background(.clear)
                      }
                    }
                    .buttonStyle(.borderless)
                    
                    Image("message")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 25, height: 25)
                      .foregroundColor(.white)
                      .overlay(
                        NavigationLink(destination: PostView(post: post)) {
                          EmptyView()
                        }
                        .opacity(0)
                      )
                    
                  } // VStack
                } // HStack
                .frame(width: 330)
            }.padding()
            
        }.onAppear {
            fetchUserName()
            checkUserLikes()
            post.getLocation { locationString in
              location = locationString
            }
        }
    }
  
  private func toggleLikePost(post: Post) {
    if let liked = userLiked {
      if liked {
          dbDocuments.unlikePost(post_id: post.id!)
      } else {
          dbDocuments.likePost(post_id: post.id!)
      }
    }
  }
  
    private func fetchUserName() {
        userName = dbDocuments.getUserName(user_id: post.user_id.documentID)
    }
    
    private func checkUserLikes(){
        if let id = post.id{
            userLiked = dbDocuments.checkUserLikes(id: id)
        }
    }
}

//struct PostRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostRowView()
//    }
//}
