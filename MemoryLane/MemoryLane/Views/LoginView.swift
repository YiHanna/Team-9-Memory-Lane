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
        ZStack {
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color.gradientLight, location: 0.00),
              Gradient.Stop(color: Color.gradientDark, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: -0.77),
            endPoint: UnitPoint(x: 0.5, y: 0.74)
          )
          .edgesIgnoringSafeArea(.all)
          
          VStack() {
            Image("logo")
            
            Text("Memory Lane")
              .font(.system(size: 20))
              .bold()
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(width: 300, height: 25, alignment: .top)
              .padding(.bottom)
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .background(.clear)
              
              TextField("Username", text: $username)
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .background(.clear)
              
              SecureField("Password", text: $password)
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            Button(action: {
              userLogin(username: username, password: password)
            }) {
              Text("Login")
            }.foregroundColor(Color.taupe)
              .padding()
              .background(.white)
              .cornerRadius(10)
              .padding(.top)
              .disabled(username.isEmpty || password.isEmpty)
            
            NavigationLink(destination: RegistrationView()) {
              Text("Don't have an account? Create one here")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(.top)
            }
          }
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
//  func login() {
//      Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//          if error != nil {
//              print(error?.localizedDescription ?? "")
//          } else {
//              print("success")
//          }
//      }
//    }
}

//struct LoginView_Preview: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
