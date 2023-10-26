//
//  ContentView.swift
//  FirebaseDemo
//
//  Created by Cindy Chen on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dbDocuments = DBDocuments()
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(dbDocuments.users) { user in
                        Text(user.name)
                    }
                }.navigationBarTitle("Users")
            }
            Spacer()
            NavigationView {
                List {
                    ForEach(dbDocuments.posts) { post in
                        Text(post.description)
                    }
                }.navigationBarTitle("Posts")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
