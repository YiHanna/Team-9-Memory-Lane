//
//  ProfileEditView.swift
//  MemoryLane
//
//  Created by Hanna Luo on 11/27/23.
//

import Foundation
import SwiftUI

struct ProfileEditView: View {
  @EnvironmentObject var dbDocuments: DBDocuments
  @State var user: User
  @State var username: String
  @State var name = ""
  @State var email: String
  @State var password = ""
  @State var passwordConfirmation = ""
  @State var hometown = ""
  @State var current_city = ""
  
  @State var isEmailPasswordComplete = false
  
  @State var e_school: String = ""
  @State var m_school: String = ""
  @State var h_school: String = ""
  @State var university: String = ""
  
  @Environment(\.defaultMinListRowHeight) var minRowHeight
  @State private var isShowingUni: Bool = false
  
  @ObservedObject var eViewModel = ESchoolViewModel()
  @ObservedObject var mViewModel = MSchoolViewModel()
  @ObservedObject var hViewModel = HSchoolViewModel()
  @ObservedObject var uViewModel = UniViewModel()
  
  init(user: User) {
    _user = State(initialValue: user)
    _isEmailPasswordComplete = State(initialValue: false)
    _name = State(initialValue: user.name)
    _username = State(initialValue: user.username)
    _email = State(initialValue: user.email)
    _password = State(initialValue: user.password)
    _passwordConfirmation = State(initialValue: user.password)
    _hometown = State(initialValue: user.hometown)
    _current_city = State(initialValue: user.current_city)
    if let eleschool = user.schools["elementary_school"] {
      _e_school = State(initialValue: eleschool)
    } else {
      _e_school = State(initialValue: "")
    }
    if let mschool = user.schools["middle_school"] {
      _m_school = State(initialValue: mschool)
    } else {
      _m_school = State(initialValue: "")
    }
    if let hschool = user.schools["high_school"] {
      _h_school = State(initialValue: hschool)
      hViewModel.searchQuery = hschool
    } else {
      _h_school = State(initialValue: "")
    }
    if let uni = user.schools["university"] {
      _university = State(initialValue: uni)
    } else {
      _university = State(initialValue: "")
    }
    hViewModel.showLocationResults = false
  }
    
  var body: some View {
    ScrollView {
      VStack{
        VStack{
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
          VStack {
            Text("Elementary School")
              .multilineTextAlignment(.leading)
              .padding(.top)
            TextField("Enter your elementary school", text: $e_school)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if (eViewModel.showLocationResults && !eViewModel.searchResults.isEmpty){
              List(eViewModel.searchResults, id: \.title) { result in
                Text(result.title).onTapGesture {
                  eViewModel.selectLocation(result)
                  e_school = result.title
                }
              }
              .listStyle(PlainListStyle())
              .background(Color.white)
              .cornerRadius(10)
              .padding()
              .zIndex(1)
              .frame(minHeight: minRowHeight * 10)
            }
            Spacer()
          }
          
          VStack{
            Text("Middle School")
              .multilineTextAlignment(.leading)
            TextField("Enter your middle school", text: Binding(
              get: { m_school },
              set: {
                m_school = $0
                mViewModel.searchQuery = $0
              }
            ))
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            if (mViewModel.showLocationResults && !mViewModel.searchResults.isEmpty) {
              List(mViewModel.searchResults, id: \.title) { result in
                Text(result.title).onTapGesture {
                  mViewModel.selectLocation(result)
                  m_school = result.title
                }
              }
              .listStyle(PlainListStyle())
              .background(Color.white)
              .cornerRadius(10)
              .padding()
              .zIndex(1)
              .frame(minHeight: minRowHeight * 10)
            }
            Spacer()
          }
          
          VStack{
            Text("High School")
              .multilineTextAlignment(.leading)
            TextField("Enter your high school", text: Binding(
              get: { h_school },
              set: {
                h_school = $0
                hViewModel.searchQuery = $0
              }
            ))
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            if (hViewModel.showLocationResults && !hViewModel.searchResults.isEmpty) {
              List(hViewModel.searchResults, id: \.title) { result in
                Text(result.title).onTapGesture {
                  hViewModel.selectLocation(result)
                  h_school = result.title
                }
              }
              .listStyle(PlainListStyle())
              .background(Color.white)
              .cornerRadius(10)
              .padding()
              .zIndex(1)
              .frame(minHeight: minRowHeight * 10)
            }
            Spacer()
          }
          
          VStack{
          Text("University")
            .multilineTextAlignment(.leading)
          TextField("Enter your university", text: Binding(
                          get: { university },
                          set: {
                            university = $0
                            uViewModel.searchQuery = $0
                          }
                      ))
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
            if (uViewModel.showLocationResults && !uViewModel.searchResults.isEmpty) {
              List(uViewModel.searchResults, id: \.title) { result in
                Text(result.title).onTapGesture {
                  uViewModel.selectLocation(result)
                  university = result.title
                }
              }
              .listStyle(PlainListStyle())
              .background(Color.white)
              .cornerRadius(10)
              .padding()
              .zIndex(1)
              .frame(minHeight: minRowHeight * 10)
            }
            Spacer()
          }
          
          Text("Current City")
            .multilineTextAlignment(.leading)
          TextField("Enter your current city", text: $current_city)
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }.onChange(of: e_school) { _ in
          // Update the search results based on the current text
          eViewModel.searchQuery = e_school
      }
        
        Button(action: updateUser) {
          Text("Update")
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding(.top)
        .background(NavigationLink("", destination: ProfileView(user: user)))
        .disabled(name.isEmpty || email.isEmpty || !isEmail(email))
      }
    }
  }
    
  private func updateUser() {
    dbDocuments.updateUser(id: user.id!, data: [
      "username": username,
      "current_city": current_city,
      "email": email,
      "hometown": hometown,
      "name": name,
      "password": password,
      "schools": [
        "elementary_school": e_school,
        "middle_school": m_school,
        "high_school": h_school,
        "university": university
      ]
    ])
  }
  
  private func isEmail(_ string: String) -> Bool {
      if string.count > 100 {
          return false
      }
//      let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
      let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
      return emailPredicate.evaluate(with: string)
  }
}

struct ProfileEditView_Preview: PreviewProvider {
    static var previews: some View {
      if let user1 = dbDocuments.getUserByUsername(username: "user1") {
        ProfileEditView(user: user1)
      } else {
        RegistrationView()
      }
    }
}
