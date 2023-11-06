//
//  ProfileView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var user: User?
    var body: some View {
      if let u = user {
        UserProfileView(user: u).environmentObject(dbDocuments)
      } else {
        LoginView().environmentObject(dbDocuments)
      }
    }
}

struct UserProfileView: View {
    @EnvironmentObject var dbDocuments: DBDocuments
    var user: User
    var body: some View {
      VStack {
//         profileImage
//             .resizable()
//             .aspectRatio(contentMode: .fit)
//             .frame(width: 100, height: 100)
//             .clipShape(Circle())
//             .padding()
         
        Text(user.name)
             .font(.title)
         
        Text(user.username)
             .font(.subheadline)
             .foregroundColor(.gray)
         
         Spacer()
     }
     .padding()
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: nil)
//    }
//}
