//
//  ContentView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 10/31/23.
//

import SwiftUI
import CoreData

var dbDocuments = DBDocuments()

struct ContentView: View {
    var body: some View {
        LoginView().environmentObject(dbDocuments)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
