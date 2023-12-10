//
//  ContentView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 10/31/23.
//

import SwiftUI
import CoreData

var dbDocuments = DBDocuments()

extension Color {
  static var beige: Color {
    Color(red: 0.96078, green: 0.95294, blue: 0.92941)
  }
  
  static var darkBeige: Color {
    Color(red: 0.89804, green: 0.88627, blue: 0.86275)
  }
  
  static var brown: Color {
    Color(red: 0.44314, green: 0.23922, blue: 0)
  }
  
  static var taupe: Color {
    Color(red: 0.66, green: 0.62, blue: 0.57)
  }
  
  static var gradientLight: Color {
    Color(red: 0.9, green: 0.89, blue: 0.86).opacity(0.82)
  }
  
  static var gradientDark: Color {
    Color(red: 0.66, green: 0.62, blue: 0.57)
  }
}

struct ContentView: View {
    var body: some View {
        LoginView().environmentObject(dbDocuments)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
