//
//  HomeView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/1/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var body: some View {
      NavigationView {
          List {
              ForEach(dbDocuments.posts) { post in
                PostRowView(post: post)
              }
          }
          .navigationBarTitle("Posts")
          .navigationBarItems(trailing:
            NavigationLink(destination: AddPostView()) {
                Image(systemName: "plus")
            }.environmentObject(dbDocuments)
          )
      }
      .navigationBarBackButtonHidden(true)
      
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
