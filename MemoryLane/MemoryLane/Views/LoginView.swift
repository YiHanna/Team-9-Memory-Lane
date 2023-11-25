//
//  LoginView.swift
//  MemoryLane
//
//  Created by Hanna Luo on 11/5/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
  @EnvironmentObject var dbDocuments: DBDocuments
  @State var username = ""
  @State var password = ""
  @State var isLoggedIn = false
  @State var user: User? = nil
  var body: some View {
    if isLoggedIn {
      AppView(user: user)
    } else {
      NavigationView {
        VStack() {
          Text("Memory Lane")
            .font(.largeTitle)
            .padding(.bottom)
          Text("Username")
            .padding(.top)
          TextField("Enter Username", text: $username)
            .padding([.leading, .bottom, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
          
          Text("Password")
          SecureField("Enter Password", text: $password)
            .padding([.leading, .bottom, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
          
            NavigationLink(destination: RegistrationView()) {
              Text("New User? Register Here ->")
          }
          Button(action: {
            userLogin(username: username, password: password)
          }) {
            Text("Login")
          }.foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.top)
            .disabled(username.isEmpty || password.isEmpty)
        }
      }
    }
  }
  func userLogin(username:String, password:String) {
//    var user = dbDocuments.getUserByUsername(username: username)
    if let dbuser = dbDocuments.getUserByUsername(username: username) {
      if dbuser.password == password {
        isLoggedIn = true
        user = dbuser
        print("\(username) logged in")
        dbDocuments.setCurrUser(user_id: dbuser.id)
        print("current user is: \(dbDocuments.currUser)")
      } else {
        print("incorrect password")
      }
    } else {
      print("incorrect username")
    }
  }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
