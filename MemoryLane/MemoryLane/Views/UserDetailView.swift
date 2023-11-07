//
//  UserDetailView.swift
//  MemoryLane
//
//  Created by Sunny Liang on 11/5/23.
//

import SwiftUI

struct UserDetailView: View {
    var user: User
    var body: some View {
        VStack {
            Text("Name: \(user.name)")
            Text("Username: \(user.username)")
        }
        .navigationTitle(user.name)
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
