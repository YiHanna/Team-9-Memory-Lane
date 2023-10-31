//
//  DBDocuments.swift
//  Memory Lane
//
//  Created by Hanna Luo on 10/26/23.
//

import Foundation

import Combine
import Firebase
import FirebaseFirestore


class DBDocuments: ObservableObject {
  // Set up properties here
  
    @Published var users : [User] = []
    @Published var posts : [Post] = []
    private let store = Firestore.firestore()
  
    init() {
        get()
    }

    func get() {
        store.collection("user").addSnapshotListener { querySnapshot, error in
            if let error = error {
              print("Error getting user: \(error.localizedDescription)")
              return
            }

            self.users = querySnapshot?.documents.compactMap { document in
              try? document.data(as: User.self)
            } ?? []
        }
        
        store.collection("post").addSnapshotListener { querySnapshot, error in
            if let error = error {
              print("Error getting post: \(error.localizedDescription)")
              return
            }

            self.posts = querySnapshot?.documents.compactMap { document in
              try? document.data(as: Post.self)
            } ?? []
        }
    }
}
