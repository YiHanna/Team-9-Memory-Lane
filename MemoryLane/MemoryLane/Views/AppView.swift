//
//  AppView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct AppView: View {
    var dbDocuments = DBDocuments()
    var body: some View {
        TabView {
            HomeView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            ProfileView().tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }
        .environmentObject(dbDocuments)
        .navigationBarBackButtonHidden(true)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
