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
            VStack{
                Spacer()
                VStack{
                    Text("Today's Prompt")
                    Text("What was one of your childhood Halloween costumes?")
                }.background(Color(red: 0.949, green: 0.941, blue: 0.925, opacity: 1.0))
                
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
            
        }.navigationBarBackButtonHidden(true)
            .background(Color.red)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
