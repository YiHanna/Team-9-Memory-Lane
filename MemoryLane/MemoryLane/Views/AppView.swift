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
  var dbDocuments = DBDocuments()
  var body: some View {
    if isLoggedIn {
      TabView {
        HomeView().tabItem {
          Image(systemName: "house")
          Text("Home")
        }
        ProfileView(user: user).tabItem {
          Image(systemName: "person.crop.circle")
          Text("Profile")
        }
//        FriendsView().tabItem {
//            Text("Friends")
//        }
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
