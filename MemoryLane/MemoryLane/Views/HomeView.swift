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
          ZStack {
            Color.beige.edgesIgnoringSafeArea(.all)
            VStack {
              ZStack {
                RoundedRectangle(cornerRadius: 10)
                  .fill(Color.white)
                  .frame(width: 360, height: 75)
                  .cornerRadius(10)
                  .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                
                NavigationLink(destination: AddPostView(showPrompt: true)) {
                  VStack{
                    Text("Today's Prompt")
                      .foregroundColor(.brown)
                    if let p = dbDocuments.currPrompt{
                      Text(p.text)
                        .foregroundColor(.black)
                    } else {
                      Text(prompt)
                        .foregroundColor(.black)
                    }
                  }
                }.environmentObject(dbDocuments)
              }
              
              List {
                ForEach(dbDocuments.posts) { post in
                  NavigationLink(destination: PostView(post: post)) {
                    PostRowView(post: post)
                  }.environmentObject(dbDocuments)
                }
              }
              .background(Color.beige)
              .scrollContentBackground(.hidden)
            }
          }
          .navigationBarBackButtonHidden(true)
          .navigationBarTitle("Memory Lane", displayMode: .inline)
          .navigationBarItems(trailing:
            NavigationLink(destination: AddPostView(showPrompt: false)) {
              Image(systemName: "plus")
                .foregroundColor(.brown)
            }.environmentObject(dbDocuments)
          )
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
