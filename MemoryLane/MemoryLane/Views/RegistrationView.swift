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
    
    @State private var errorMessage: String? = nil
    @State private var showErrorAlert: Bool = false
  
  var body: some View {
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
        
        VStack {
          Image("logo")
          
          Text("Sign up for Memory Lane")
            .font(.system(size: 20))
            .bold()
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(width: 300, height: 25, alignment: .top)
          
          Text("Create an account and travel down memory lane with friends from yesterday, today, and tomorrow.")
            .font(.system(size: 15))
            .italic()
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(width: 330, alignment: .top)
          
          Group {
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
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
                .foregroundColor(.white)
                .background(.clear)
              
              SecureField("Password", text: $password)
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              SecureField("Confirm Password", text: $passwordConfirmation)
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .offset(x: 30)
                .foregroundColor(.white)
            }
          }
          
          Button(action: {
              if let error = Helpers.validateRegistration(username, password, passwordConfirmation) {
                  self.errorMessage = error
                  self.showErrorAlert = true
              } else {
                  isComplete = true
              }
          }) {
            Text("Next")
          }
          .foregroundColor(Color.taupe)
          .padding()
          .background(.white)
          .cornerRadius(10)
          .padding(.top)
          .alert(isPresented: $showErrorAlert) {
              Alert(
                  title: Text("Error"),
                  message: Text(errorMessage ?? "Unknown error"),
                  dismissButton: .default(Text("OK")) {
                      self.errorMessage = nil
                  }
              )
          }
        }
      }
    }
    .navigationBarBackButtonHidden(true)
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
  
  @ObservedObject var eViewModel = ESchoolViewModel()
  @ObservedObject var mViewModel = MSchoolViewModel()
  @ObservedObject var hViewModel = HSchoolViewModel()
  @ObservedObject var uViewModel = UniViewModel()
  @Environment(\.defaultMinListRowHeight) var minRowHeight
  
  @State var user: User? = nil
  
  @State private var isUserCreated = false
  
  var body: some View {
    ScrollView{
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
        
        VStack {
          Image("logo")
          
          Group {
            Text("A little bit about you")
              .font(.system(size: 20))
              .bold()
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(width: 300, height: 25, alignment: .top)
            
            Text("Help us help you find your old connections.")
              .font(.system(size: 15))
              .italic()
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(width: 330, alignment: .top)
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Name", text: $name)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Email", text: $email)
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Hometown", text: $hometown)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
          }
          
          Group {
            Text("The following fields are optional but recommended for the best experience.")
              .font(.system(size: 15))
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(width: 330, alignment: .top)
              .padding([.top])
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Your elementary school", text: $eViewModel.searchQuery)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
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
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Your middle school", text: $m_school)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Your high school", text: $h_school)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Your university", text: $university)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
            
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 2)
                .frame(width: 330, height: 40)
                .foregroundColor(.white)
                .background(.clear)
              
              TextField("Your current city", text: $current_city)
                .padding([.leading, .trailing])
                .autocapitalization(.words)
                .offset(x: 30)
                .foregroundColor(.white)
            }
          }
          
          Button(action: registerUser) {
            Text("Register")
          }
          .foregroundColor(Color.taupe)
          .padding()
          .background(.white)
          .cornerRadius(10)
          .padding(.top)
          .background(NavigationLink("", destination: AppView(user: user), isActive: $isUserCreated))
          .disabled(name.isEmpty || email.isEmpty || !Helpers.isEmail(email))
        }
      }
    }
  }
    
  private func registerUser() {
      let viewModel = LocationViewModel()
      
      var data = [
        "username": username,
        "current_city": current_city,
        "email": email,
        "hometown": hometown,
        "name": name,
        "friends": [],
        "schools": [
          "elementary_school": e_school,
          "middle_school": m_school,
          "high_school": h_school,
          "university": university
        ],
        "posts_liked": []
      ] as [String : Any]
      
      viewModel.getGeoPoint(searchQuery: hometown){geoPoint  in
          data["hometown_geo"] = geoPoint
          
          dbDocuments.createUser(data: data, password: password){result in
              user = dbDocuments.currUser
              isUserCreated = true
          }
      }
  }
}
