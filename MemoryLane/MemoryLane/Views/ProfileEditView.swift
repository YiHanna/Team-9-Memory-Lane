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
  @State var photo: String?
  
  @State var showImagePicker: Bool = false
  @State var isEmailPasswordComplete = false
  @State var image: UIImage? = nil
  
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
    _hometown = State(initialValue: user.hometown)
    _current_city = State(initialValue: user.current_city)
    _photo = State(initialValue: user.photo)
    
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
        Spacer()
        Button(action: {
          self.showImagePicker = true
        }) {
          if let picture = image {
            Image(uiImage: picture).resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 100, height: 100)
              .clipShape(Circle())
              .padding()
          } else if let photoUrl = photo {
            AsyncImage(url: URL(string: photoUrl)) { image in
              image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
            } placeholder: {
              Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
            }
            .edgesIgnoringSafeArea(.all)
          } else {
            Color(red: 0.811, green: 0.847, blue: 0.863, opacity: 1.0)
              .edgesIgnoringSafeArea(.all)
              .frame(width: 100, height: 100)
              .clipShape(Circle())
              .padding()
          }
        }
        
        Group {
          HStack{
            Text("Name")
            Text("*")
              .foregroundColor(Color.red)
          }
          .font(.system(size: 14))
          .frame(maxWidth: .infinity, alignment: .leading)

          TextField("Enter your name", text: $name)
            .font(.system(size: 14))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.words)

          HStack{
            Text("Email")
            Text("*")
              .foregroundColor(Color.red)
          }
          .font(.system(size: 14))
          .frame(maxWidth: .infinity, alignment: .leading)

          TextField("Enter your email", text: $email)
            .font(.system(size: 14))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)

          Text("Hometown")
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)

          TextField("Enter your hometown", text: $hometown)
            .font(.system(size: 14))
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        VStack{
          VStack{
            Text("Elementary School")
              .font(.system(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Enter your elementary school", text: Binding(
              get: { e_school },
              set: {
                e_school = $0
                eViewModel.searchQuery = $0
              }
            ))
              .font(.system(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
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
              .font(.system(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Enter your middle school", text: Binding(
              get: { m_school },
              set: {
                m_school = $0
                mViewModel.searchQuery = $0
              }
            )).font(.system(size: 14))
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
              .font(.system(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Enter your high school", text: Binding(
              get: { h_school },
              set: {
                h_school = $0
                hViewModel.searchQuery = $0
              }
            ))
            .font(.system(size: 14))
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
              .font(.system(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
          TextField("Enter your university", text: Binding(
                          get: { university },
                          set: {
                            university = $0
                            uViewModel.searchQuery = $0
                          }
                      ))
            .font(.system(size: 14))
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
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
          TextField("Enter your current city", text: $current_city)
            .font(.system(size: 14))
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        Button(action: updateUser) {
          Text("Update")
            .foregroundColor(.white)
            .padding()
            .background(Color.taupe)
            .cornerRadius(10)
        }
        .padding(.top)
        .background(NavigationLink("", destination: ProfileView()))
        .disabled(name.isEmpty || email.isEmpty || !isEmail(email))
      }.padding(.horizontal, 15)
        .fullScreenCover(isPresented: $showImagePicker) {
          PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
        }
    }
  }
    
  private func updateUser() {
    var newData:[String : Any] = [
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
      ],
    ]
    if let img = image {
        dbDocuments.uploadImage(img) { (url) in
            if let imageURL = url {
                newData["photo"] = imageURL.absoluteString
                print("Image URL: \(newData["photo"])")
                dbDocuments.updateUser(id: user.id!, data: newData)
            } else {
                dbDocuments.updateUser(id: user.id!, data: newData)
                print("Failed to upload the image.")
            }
        }
    } else {
        print("no profile image")
        dbDocuments.updateUser(id: user.id!, data: newData)
    }
  }
  
  private func isEmail(_ string: String) -> Bool {
      if string.count > 100 {
          return false
      }
      let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
      return emailPredicate.evaluate(with: string)
  }
}


//struct ProfileEditView_Preview: PreviewProvider {
//    static var previews: some View {
//      if let user1 = dbDocuments.getUserByUsername(username: "user1") {
//        ProfileEditView(user: user1)
//      } else {
//        RegistrationView()
//      }
//    }
//}
