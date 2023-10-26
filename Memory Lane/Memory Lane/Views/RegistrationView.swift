//
//  RegistrationView.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import SwiftUI

struct RegistrationView: View {
//  @ObservedObject var dbDocuments = DBDocuments()
  @State private var username = ""
  @State private var name = ""
  var body: some View {
    VStack {
      Text("Username")
        .multilineTextAlignment(.leading)
      TextField("Enter Username", text: $username)
      
      Text("Display Name")
        .multilineTextAlignment(.leading)
      TextField("FirstName, LastName", text: $name)
      
    }
  }
}

struct RegistrationView_Preview: PreviewProvider {
  static var previews: some View {
    RegistrationView()
  }
}
