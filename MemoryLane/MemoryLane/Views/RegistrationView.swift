//
//  RegistrationView.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import SwiftUI

struct RegistrationView: View {
  @State var username = ""
  @State var name = ""
  @State var email = ""
  @State var password = ""
  @State var passwordConfirmation = ""
  @State var hometown = ""
  @State var current_city = ""
  
  @State var isEmailPasswordComplete = false
  
  var body: some View {
    NavigationView {
      if isEmailPasswordComplete {
        RegistrationViewUserInfo(username: $username, name: $name, email: $email, password: $password, hometown: $hometown, current_city: $current_city)
      } else {
        RegistrationViewInit(username: $username, password: $password, passwordConfirmation: $passwordConfirmation, isComplete: $isEmailPasswordComplete)
      }
    }.navigationBarBackButtonHidden(true)
  }
}

struct RegistrationViewInit: View {
  @Binding var username: String
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
        
        HStack{
          Text("Username")
            .multilineTextAlignment(.leading)
          Text("*")
            .foregroundColor(Color.red)
            .multilineTextAlignment(.leading)
        }
        TextField("Enter Username", text: $username)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
        
        HStack{
          Text("Password")
            .multilineTextAlignment(.leading)
          Text("*")
            .foregroundColor(Color.red)
            .multilineTextAlignment(.leading)
        }
          .multilineTextAlignment(.leading)
        SecureField("Enter Password", text: $password)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
        
        HStack{
          Text("Confirm Password")
            .multilineTextAlignment(.leading)
          Text("*")
            .foregroundColor(Color.red)
            .multilineTextAlignment(.leading)
        }
          .multilineTextAlignment(.leading)
        SecureField("Confirm Password", text: $passwordConfirmation)
          .padding([.top, .leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
        
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
        .disabled(username.isEmpty || password.isEmpty || passwordConfirmation.isEmpty || (password != passwordConfirmation) || !usernameValid())
      }
    }.navigationBarBackButtonHidden(true)
  }
  private func usernameValid() -> Bool {
    let check = dbDocuments.getUserByUsername(username: username)
    if check != nil {
      print("username exists")
      return false
    }
    return true
  }
}

struct RegistrationViewUserInfo: View {
  @Binding var username: String
  @Binding var name: String
  @Binding var email: String
  @Binding var password: String
  @Binding var hometown: String
  @Binding var current_city: String
  
  @State var e_school: String = ""
  @State var m_school: String = ""
  @State var h_school: String = ""
  @State var university: String = ""
  
  @State var user: User? = nil
  
  @State private var isUserCreated = false
  
  var body: some View {
    VStack {
      VStack{
        Text("A little bit about you")
          .font(.title3)
          .fontWeight(.heavy)
        Text("Help us help you find your old connections.")
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.all, 5.0)
        
        HStack{
          Text("Name")
            .multilineTextAlignment(.leading)
          Text("*")
            .foregroundColor(Color.red)
            .multilineTextAlignment(.leading)
        }
          .multilineTextAlignment(.leading)
        TextField("Enter your name", text: $name)
          .padding([.leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.words)
        
        HStack{
          Text("Email")
            .multilineTextAlignment(.leading)
          Text("*")
            .foregroundColor(Color.red)
            .multilineTextAlignment(.leading)
        }
          .multilineTextAlignment(.leading)
        TextField("Enter your email", text: $email)
          .padding([.leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
        
        Text("Hometown")
          .multilineTextAlignment(.leading)
        TextField("Enter your hometown", text: $hometown)
          .padding([.leading, .trailing])
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      
      VStack{
        Text("Elementary School")
            .multilineTextAlignment(.leading)
            .padding(.top)
        TextField("Enter your elementary school", text: $e_school)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
        Text("Middle School")
            .multilineTextAlignment(.leading)
        TextField("Enter your middle school", text: $m_school)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
        Text("High School")
            .multilineTextAlignment(.leading)
        TextField("Enter your high school", text: $h_school)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
        Text("University")
            .multilineTextAlignment(.leading)
        TextField("Enter your university", text: $university)
            .padding([.leading,.trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
        Text("Current City")
            .multilineTextAlignment(.leading)
        TextField("Enter your current city", text: $current_city)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      
      Button(action: registerUser) {
        Text("Register")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding(.top)
      .background(NavigationLink("", destination: AppView(user: user), isActive: $isUserCreated))
      .disabled(name.isEmpty || email.isEmpty || !isEmail(email))
    }
  }
    
  private func registerUser() {
    dbDocuments.createUser(data: [
      "username": username,
      "current_city": current_city,
      "email": email,
      "hometown": hometown,
      "name": name,
      "password": password,
      "friends": [],
      "schools": [
        "elementary_school": e_school,
        "middle_school": m_school,
        "high_school": h_school,
        "university": university
      ],
      "posts_liked": []
    ])
    
    dbDocuments.getCurrUser(){usr in
       user = usr
    }
    isUserCreated = true
  }
  
  private func isEmail(_ string: String) -> Bool {
      if string.count > 100 {
          return false
      }
      let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
      //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
      return emailPredicate.evaluate(with: string)
  }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
