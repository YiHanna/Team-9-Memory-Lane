//
//  RegistrationView.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import SwiftUI

var dbDocuments = DBDocuments()

struct RegistrationView: View {
  @State var username = ""
  @State var name = ""
  @State var email = ""
  @State var password = ""
  @State var passwordConfirmation = ""
  @State var schools:[String] = []
  @State var hometown = ""
  @State var current_city = ""
  
  @State var isEmailPasswordComplete = false
  
  var body: some View {
    NavigationView {
      if isEmailPasswordComplete {
        RegistrationViewUserInfo(username: $username, name: $name, schools: $schools, hometown: $hometown, current_city: $current_city, email: $email, password: $password)
      } else {
        RegistrationViewInit(email: $email, password: $password, passwordConfirmation: $passwordConfirmation, isComplete: $isEmailPasswordComplete)
      }
    }
  }
}

struct RegistrationViewInit: View {
  @Binding var email: String
  @Binding var password: String
  @Binding var passwordConfirmation: String
  @Binding var isComplete: Bool
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Sign up for Memory Lane")
          .font(.title3)
          .fontWeight(.heavy)
        Text("Create an account and travel down memory lane with friends from yesterday, today, and tomorrow.")
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.all, 5.0)
        
        TextField("Enter Email", text: $email)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        SecureField("Enter Password", text: $password)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        SecureField("Confirm Password", text: $passwordConfirmation)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button(action: {
                isComplete = true
            }) {
                Text("Next")
            }
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.top)
      }
    }
  }
}

struct RegistrationViewUserInfo: View {
  @Binding var username: String
  @Binding var name: String
  @Binding var schools:[String]
  @Binding var hometown: String
  @Binding var current_city: String
  @Binding var email: String
  @Binding var password: String
  
  @State private var isUserCreated = false
  
  var body: some View {
    VStack {
      Text("A little bit about you")
        .font(.title3)
        .fontWeight(.heavy)
      Text("Help us help you find your old connections.")
        .font(.body)
        .multilineTextAlignment(.center)
        .padding(.all, 5.0)
      
      Text("Name")
        .multilineTextAlignment(.leading)
        .padding(.top)
      TextField("Enter your name", text: $name)
        .padding([.leading, .bottom, .trailing])
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Text("Username")
        .multilineTextAlignment(.leading)
        .padding(.top)
      TextField("Enter your name", text: $username)
        .padding([.leading, .bottom, .trailing])
        .textFieldStyle(RoundedBorderTextFieldStyle())

      
      Button(action: registerUser) {
        Text("Register")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding(.top)
      .background(NavigationLink("", destination: AppView(), isActive: $isUserCreated))
    }
  }
  func registerUser() {
    dbDocuments.createUser(data: [
      "username": username,
      "current_city": username,
      "email": email,
      "hometown": hometown,
      "name": name,
      "password": password,
      "friends": [],
      "schools": [
        "elementary_school": "",
        "middle_school": "",
        "high_school": "",
        "university": ""
      ],
      "posts_liked": []
    ])
    
    isUserCreated = true
  }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
