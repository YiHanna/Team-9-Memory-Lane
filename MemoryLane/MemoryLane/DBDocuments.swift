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
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit


class DBDocuments: ObservableObject {
  // Set up properties here
  
    @Published var users : [User] = []
    @Published var posts : [Post] = []
    @Published var currUser : DocumentReference?
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
  
      func createUser(data : [String:Any]){
          let reference: DocumentReference? = store.collection("user").addDocument(data: data) { error in
              if let error = error {
                  print("Error adding document: \(error)")
              }
          }
          if let ref = reference{
              print("Document added with ID: \(ref.documentID)")
              currUser = ref
          }
      }
      
    func getUserName(user_ref: DocumentReference, completion: @escaping (String?) -> Void) {
          user_ref.getDocument { (document, error) in
              if let error = error {
                  print("Error fetching document: \(error)")
                  completion(nil)  // Call completion with nil
              } else if let document = document {
                  let tmp = try? document.data(as: User.self)
                  if let user = tmp {
                      completion(user.name)  // Call completion with user name
                  } else {
                      print("Document does not exist \(user_ref), \(document)")
                      completion(nil) 
                  }
              }
//            else {
//                  print("Document does not exist \(user_ref), \(document)")
//                  completion(nil)  // Call completion with nil
//              }
          }
      }

  func getUserByUsername(username: String) -> User? {
      for user in users {
        if user.username == username {
          return user
        }
      }
      return nil
    }
  
  func getUserPosts(user_id: String?, completion: @escaping ([Post]?) -> Void) {
    if let uid = user_id {
      let documentPath = "user/\(uid)"
      let documentReference = store.document(documentPath)
      let postsRef = store.collection("post").whereField("user_id", isEqualTo: documentReference)
      
      postsRef.getDocuments { (querySnapshot, error) in
        if let error = error {
          // Handle the error
          print("Error getting posts: \(error.localizedDescription)")
          completion(nil)
        } else {
          var result: [Post] = []
          
          for document in querySnapshot!.documents {
            if let post = try? document.data(as: Post.self) {
              result.append(post)
            }
          }
          completion(result)
        }
      }
    } else {
      completion(nil)
    }
  }
  
    func getUserByRef(user_ref: DocumentReference, completion: @escaping (User?) -> Void) {
        user_ref.getDocument { (document, error) in
            if let error = error {
                print("Error fetching User: \(error)")
                completion(nil)  // Call completion with nil
            } else if let document = document, document.exists {
                let tmp = try? document.data(as: User.self)
                if let user = tmp {
                    completion(user)  // Call completion with user name
                } else {
                    completion(nil)  // Call completion with nil
                }
            } else {
                print("User does not exist")
                completion(nil)  // Call completion with nil
            }
        }
    }
    
    func getUserById(id : String?) -> DocumentReference? {
        if id == nil {
            return nil
        } else {
            let ref = store.collection("user").document(id!)
            return ref
        }
    }
  
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        let dispatchGroup = DispatchGroup()

        var users: [User] = []
      
        store.collection("user").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting user documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let documentReference = document.reference
                    dispatchGroup.enter()

                    self.getUserByRef(user_ref: documentReference) { user in
                        if user != nil {
                            users.append(user!)
                        } else {
                        }
                      dispatchGroup.leave()

                    }
                }
              // Notify the dispatch group when all users are fetched
              dispatchGroup.notify(queue: .main) {
              // Call the completion with the users array
              completion(users)
              }
            }
        }
        completion(users)
    }
  
    func getFriends(user: User) -> [User] {
      var friends: [User] = []
      for f in user.friends {
          dbDocuments.getUserByRef(user_ref: f) { friend in
              if let friend = friend {
                  friends.append(friend)
              }
          }
      }
      return friends
    }
  
  func getFriendReferencesFromDB(user: User, completion: @escaping ([DocumentReference]?) -> Void) {
    let user_ref = self.getUserById(id: user.id)
    if let user_ref = user_ref {
      user_ref.getDocument { (document, error) in
        if let error = error {
          print("Error getting user document: \(error)")
          completion(nil)
          return
        }
        
        if let document = document, document.exists {
          if let references = document.get("friends") as? [DocumentReference] {
            completion(references)
          } else {
            completion(nil) // The field is not an array of document references
          }
        } else {
          print("User document does not exist")
          completion(nil) // User document doesn't exist
        }
      }
    }
  }
  
  func getFriendsFromDB(user: User, completion: @escaping ([User]?) -> Void) {
      var friends: [User] = []
      self.getFriendReferencesFromDB(user: user) { references in
          if let references = references {
              let dispatchGroup = DispatchGroup()
              for ref in references {
                  dispatchGroup.enter()
                  self.getUserByRef(user_ref: ref) { u in
                      if let u = u {
                          friends.append(u)
                      }
                      dispatchGroup.leave()
                  }
              }
              dispatchGroup.notify(queue: .main) {
                  completion(friends)
              }
          } else {
              completion(nil)
          }
      }
  }
    
    func createPost(data : [String:Any]){
        store.collection("post").addDocument(data: data){ error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Post created!")
            }
        }
    }
    
    func setCurrUser(user_id : String?){
        if let id = user_id{
            currUser = store.collection("user").document(id)
            print("current user set")
        }
    }
  
    func getCurrUser(completion: @escaping (User?) -> Void){
         if let user_ref = currUser{
             getUserByRef(user_ref: user_ref){ user in
                 return completion(user)
             }
         }
         completion(nil)
     }

    
    func likePost(post:Post){
        if let id = post.id{
            let ref = store.collection("post").document(id)
            
            ref.updateData(["num_likes": post.num_likes + 1]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Number of post likes successfully updated: \(post.num_likes + 1)")
                }
            }
            
            // add post to the user's liked posts array
            if let user = currUser {
                
                user.updateData([
                    "posts_liked": FieldValue.arrayUnion([id])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Post successfully added to user's liked posts array")
                    }
                }
            }
            
        }
    }
    
    func unlikePost(post:Post){
        if let id = post.id{
            let ref = store.collection("post").document(id)
            
            ref.updateData(["num_likes": post.num_likes - 1]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Number of post likes successfully updated: \(post.num_likes - 1)")
                }
            }
            
            // remove post from the user's liked posts array
            if let user = currUser {
                
                user.updateData([
                    "posts_liked": FieldValue.arrayRemove([id])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Post successfully removed from user's liked posts array")
                    }
                }
            }
            
        }
    }
    
    func checkUserLikes(id:String, completion: @escaping (Bool?) -> Void){
        if let usr = currUser {
            usr.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    completion(nil)
                } else if let document = document, document.exists {
                    let tmp = try? document.data(as: User.self)
                    if let user = tmp {
                        completion(user.posts_liked.contains(id))  // Call completion with user name
                    } else {
                        completion(nil)
                    }
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
            
        }
    }
  
  
    func addFriend(user: User, friend: User, completion: @escaping (Bool) -> Void) {
        let user_ref = getUserById(id: user.id)
        let friend_ref = getUserById(id: friend.id)
        if user_ref != nil && friend_ref != nil {
            user_ref!.updateData([
                "friends": FieldValue.arrayUnion([friend_ref!])
            ])
            friend_ref!.updateData([
                "friends": FieldValue.arrayUnion([user_ref!])
            ])
            completion(true)
        } else {
            print("User or friend does not exist")
            completion(false)
        }
    }
  
    func removeFriend(user: User, friend: User, completion: @escaping (Bool) -> Void) {
        let user_ref = getUserById(id: user.id)
        let friend_ref = getUserById(id: friend.id)
        if user_ref != nil && friend_ref != nil {
            user_ref!.updateData([
                "friends": FieldValue.arrayRemove([friend_ref!])
            ])
            friend_ref!.updateData([
                "friends": FieldValue.arrayRemove([user_ref!])
            ])
            completion(true)
        } else {
            print("User or friend does not exist")
            completion(false)
        }
    }
  
    func checkFriendStatus(user: User, possibleFriend: User, completion: @escaping (Bool) -> Void) {
      for f in user.friends {
          dbDocuments.getUserByRef(user_ref: f) { friend in
            if let friend = friend {
              if friend.id == possibleFriend.id {
                completion(true)
              }
              }
          }
      }
      completion(false)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
        // Convert the UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(nil)
            return
        }
        
        // Define the storage reference
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")

        // Upload the image data to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Error uploading image to Firebase Storage: \(error!.localizedDescription)")
                completion(nil)
                return
            }

            // Get the download URL for the uploaded image
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("An error occurred while getting the download URL: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }

}
