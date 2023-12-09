//
//  AppView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct AppView: View {
  var user: User?
  @State var isLoggedIn = true
  @ObservedObject var dbDocuments = DBDocuments()
  var body: some View {
    if isLoggedIn {
      TabView {
        HomeView(dbDocuments: dbDocuments).tabItem {
          Image(systemName: "house")
          Text("Home")
        }
        FriendsView(user: user).tabItem {
          Image(systemName: "person.2")
          Text("Friends")
        }
        ProfileView().tabItem {
            Image(systemName: "person.crop.circle")
            Text("Profile")
        }
      }
      .environmentObject(dbDocuments)
      .navigationBarBackButtonHidden(true)
    } else {
      LoginView().environmentObject(dbDocuments)
    }
  }
}

//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView()
//    }
//}
