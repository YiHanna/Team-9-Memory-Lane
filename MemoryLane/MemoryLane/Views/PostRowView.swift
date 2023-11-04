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
  
    var body: some View {
        ZStack{
            if let photoUrl = post.photo{
                AsyncImage(url: URL(string: photoUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
                }
                .edgesIgnoringSafeArea(.all)
            }else{
                Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
//                    .aspectRatio(contentMode: .fill)
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
                        Button(action: {}) {
                            Image(systemName: "heart").foregroundColor(.white)
                        }
                    }.padding()
                }
            }.padding()
            
        }.onAppear {
            fetchUserName()
            post.getLocation { locationString in
              location = locationString
            }
        }
    }
  
    private func fetchUserName() {
      dbDocuments.getUserName(user_ref: post.user_id) { (fetchedName) in
          userName = fetchedName
          print("username fetched: \(userName)")
      }
    }
}

//struct PostRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostRowView()
//    }
//}
