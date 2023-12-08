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
    @State var email = ""
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
                                .background(.clear)
                            
                            SecureField("Password", text: $password)
                                .padding([.leading, .trailing])
                                .autocapitalization(.none)
                                .offset(x: 30)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            userLogin(email: email, password: password)
                        }) {
                            Text("Login")
                        }.foregroundColor(Color.taupe)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.top)
                            .disabled(email.isEmpty || password.isEmpty)
                        
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
    
    func userLogin(email:String, password:String) {
        dbDocuments.userLogin(email: email, password: password) { result in
            switch result {
            case .success(_):
                isLoggedIn = true
                print("here")
                if let dbuser = dbDocuments.getUserByEmail(email: email) {
                    user = dbuser
                    dbDocuments.setCurrUser(user_id: dbuser.id)
                    print("current user is: \(dbDocuments.currUser)")
                }
            case .failure(let error):
                // Handle error, maybe show an alert
                print("log in error \(error)")
            }
        }
    }
    
    //struct LoginView_Preview: PreviewProvider {
    //    static var previews: some View {
    //        LoginView()
    //    }
    //}
}
