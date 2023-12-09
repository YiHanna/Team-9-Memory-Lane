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
                    image.resizable().aspectRatio(contentMode: .fill)
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
                    Button(action: {
                      toggleLikePost(post: post)
                      checkUserLikes()
                     }) {
                       if let liked = userLiked {
                           Image(systemName: liked ? "heart.fill" : "heart")
                               .foregroundColor(.white)
                       }
                     }
                     .buttonStyle(.bordered)
                     .foregroundColor(Color.clear)
                     .padding()
                     .zIndex(1)
                }
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
