//
//  ContentView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 10/31/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @ObservedObject var dbDocuments = DBDocuments()
  var body: some View {
    RegistrationView()
//      VStack {
//          NavigationView {
//              List {
//                  ForEach(dbDocuments.users) { user in
//                      Text(user.name)
//                  }
//              }.navigationBarTitle("Users")
//          }
//          Spacer()
//          NavigationView {
//              List {
//                  ForEach(dbDocuments.posts) { post in
//                      Text(post.description)
//                  }
//              }.navigationBarTitle("Posts")
//          }
//      }
//      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
