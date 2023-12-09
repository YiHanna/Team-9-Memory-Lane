//
//  HomeView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/1/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var dbDocuments: DBDocuments
    @State private var prompt : String = "What was one of your childhood Halloween costumes?"
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                NavigationLink(destination: AddPostView(showPrompt: true)) {
                    VStack{
                        Text("Today's Prompt")
                        if let p = dbDocuments.currPrompt{
                            Text(p.text)
                        }else{
                            Text(prompt)
                        }
                    }.background(Color(red: 0.949, green: 0.941, blue: 0.925, opacity: 1.0))
                }.environmentObject(dbDocuments)
                
                
                List {
                    ForEach(dbDocuments.posts) { post in
                      NavigationLink(destination: PostView(post: post)) {
                        PostRowView(post: post)
                      }.environmentObject(dbDocuments)
                    }
                }
                .navigationBarTitle("Posts")
                .navigationBarItems(trailing:
                  NavigationLink(destination: AddPostView(showPrompt: false)) {
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
