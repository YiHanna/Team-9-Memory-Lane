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
import FirebaseAuth
import UIKit


class DBDocuments: ObservableObject {
  // Set up properties here
  
    @Published var users : [User] = []
    @Published var posts : [Post] = []
    @Published var prompts : [Prompt] = []
    @Published var currUser : User?
    @Published var currPrompt : Prompt?
    @Published var friends: [User] = []
    private let store = Firestore.firestore()
  
    init() {
        get()
    }

    func get() {
        // Get users from DB
        store.collection("user").addSnapshotListener { querySnapshot, error in
            if let error = error {
              print("Error getting user: \(error.localizedDescription)")
              return
            }

            self.users = querySnapshot?.documents.compactMap { document in
              try? document.data(as: User.self)
            } ?? []
        }

        // Get posts from DB
        store.collection("post").addSnapshotListener { querySnapshot, error in
            if let error = error {
              print("Error getting post: \(error.localizedDescription)")
              return
            }

            self.posts = querySnapshot?.documents.compactMap { document in
              try? document.data(as: Post.self)
            } ?? []
            
            self.posts.sort{$0 > $1}
        }
        
        // Get prompts from DB
        store.collection("prompt").addSnapshotListener { querySnapshot, error in
            if let error = error {
              print("Error getting post: \(error.localizedDescription)")
              return
            }

            self.prompts = querySnapshot?.documents.compactMap { document in
              try? document.data(as: Prompt.self)
            } ?? []
            
            for p in self.prompts {
                if p.on{
                    self.currPrompt = p
                }
            }
        }
    }
    
    func removePostFromDB(_ post: Post){
        let ref = store.collection("post").document(post.id!)
        ref.delete { error in
            if let error = error {
                print("Error removing post: \(error)")
            } else {
                print("Post successfully removed!")
                
                self.posts = self.posts.filter { $0.id != post.id }

            }
        }
    }
    
    func userLogin(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error logging in: \(error)")
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
  
    func createUser(data : [String:Any], password: String, completion: @escaping (String?) -> Void){
          Auth.auth().createUser(withEmail: data["email"] as! String, password: password) { authResult, error in
              if let error = error {
                  print("Error creating user: \(error)")
                  completion("Error creating user: \(error)")
              } else {
                  print("User was successfully created in firebase")
                  
                  let reference: DocumentReference? = self.store.collection("user").addDocument(data: data) { error in
                      if let error = error {
                          print("Error adding document: \(error)")
                      }
                  }
                  if let ref = reference{
                      let userObj = User(id: String(ref.documentID), email: data["email"] as! String, name: data["name"] as! String, username: data["username"] as! String, schools: data["schools"] as! [String : String], hometown: data["hometown"] as! String, current_city: data["current_city"] as! String, friends: [], posts_liked: [])
                      print("Document added with ID: \(ref.documentID)")
                      
                      
                      self.setCurrUser(user: userObj)
                      self.users.append(userObj)
                      completion(nil)
                  }
              }
          }
          
      }
  
  func updateUser(id: String, data : [String:Any]) {
    let ref = store.collection("user").document(id)
    ref.updateData(data){ error in
      if let error = error {
          print("Error updating document: \(error)")
      } else {
          print("Document successfully updated")
          if let index = self.users.firstIndex(where: { $0.id == id }) {
              let userObj = User(id: String(ref.documentID), email: data["email"] as! String, name: data["name"] as! String, username: data["username"] as! String, schools: data["schools"] as! [String : String], hometown: data["hometown"] as! String, current_city: data["current_city"] as! String, friends: [], posts_liked: [])
              self.users[index] = userObj
              self.currUser = userObj
          }
      }
    }
  }
      
    func getUserName(user_id: String)->String? {
        if let user = users.first(where: { $0.id == user_id }) {
            return user.name
        } else {
            print("User not found")
            return nil
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
    
    
  func getUserByEmail(email: String) -> User? {
    for user in users {    
      if user.email == email {
        return user
      }
    }
    return nil
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
  
    func setFriends() {
        for ref in currUser!.friends{
            if let f = users.first(where: { $0.id == ref.documentID }) {
                friends.append(f)
            }
        }
    }
    
    func createPost(data : [String:Any]){
        var d = data
        if let user = currUser{
            d["user_id"] = store.collection("user").document(user.id!)
            
            let postRef: DocumentReference? = store.collection("post").addDocument(data: d){ error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Post created!")
                }
            }
            
            if let ref = postRef{
                let postObj = Post(id: ref.documentID, user_id: d["user_id"] as! DocumentReference, date: data["date"] as! Timestamp, location: data["location"] as! GeoPoint, description: data["description"] as! String, num_likes: 0)
                
                self.posts.append(postObj)
            }
        }
    }
    
    func setCurrUser(user : User?){
        currUser = user
        setFriends()
    }
  
  func getUserPosts(user_id: String?) -> [Post] {
      if let uid = user_id {
          return posts.filter{$0.user_id.documentID == uid}
      }
      return []
  }

    func likePost(post_id:String){
        if let index = self.posts.firstIndex(where: { $0.id == post_id }) {
            self.posts[index].num_likes += 1
            let post = self.posts[index]
            
            let ref = store.collection("post").document(post_id)
            
            ref.updateData(["num_likes": post.num_likes]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Number of post likes successfully updated: \(post.num_likes)")
                }
            }
            
            // add post to the user's liked posts array
            if let user = currUser {
                let userref = store.collection("user").document(user.id!)
                userref.updateData([
                    "posts_liked": FieldValue.arrayUnion([post_id])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Post successfully added to user's liked posts array")
                        
                        if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                            self.users[index].posts_liked.append(post_id)
                        }
                        
                        self.currUser!.posts_liked.append(post_id)
                    }
                }
            }
        }
    
    }
    
    func unlikePost(post_id:String){
        if let index = self.posts.firstIndex(where: { $0.id == post_id }) {
            self.posts[index].num_likes -= 1
            let post = self.posts[index]
            
            let ref = store.collection("post").document(post_id)
            
            ref.updateData(["num_likes": post.num_likes]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Number of post likes successfully updated: \(post.num_likes)")
                }
            }
            
            // remove post from the user's liked posts array
            if let user = currUser {
                let userref = store.collection("user").document(user.id!)
                userref.updateData([
                    "posts_liked": FieldValue.arrayRemove([post_id])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Post successfully removed from user's liked posts array")
                        
                        if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                            self.users[index].posts_liked = self.users[index].posts_liked.filter{$0 == post_id}
                        }
                        
                        self.currUser!.posts_liked = self.users[index].posts_liked.filter{$0 == post_id}
                    }
                }
            }
        }
    }
  
  func commentPost(post:Post, comment:String){
      if let id = post.id{
          let ref = store.collection("post").document(id)
          // remove post from the user's liked posts array
          if let user = currUser {
            let postPath = "post/\(id)"
            let postReference = store.document(postPath)
              var data = [
                "post_id": postReference,
                "user_id": user.id,
                "time": Date.now,
                "text": comment
              ] as [String : Any]
              store.collection("comment").addDocument(data: data){ error in
                  if let error = error {
                      print("Error adding document: \(error)")
                  } else {
                      print("Comment created!")
                  }
              }
            }else {
              print("1")
            }
          }else{
            print("2")
          }
      }
  
  func getPostComments(post_id: String?, completion: @escaping ([Comment]?) -> Void) {
    if let uid = post_id {
      let documentPath = "post/\(uid)"
      let documentReference = store.document(documentPath)
      let commentRef = store.collection("comment").whereField("post_id", isEqualTo: documentReference)
      
      commentRef.getDocuments { (querySnapshot, error) in
        if let error = error {
          // Handle the error
          print("Error getting comments: \(error.localizedDescription)")
          completion(nil)
        } else {
          var result: [Comment] = []
          
          for document in querySnapshot!.documents {
            if let comment = try? document.data(as: Comment.self) {
              result.append(comment)
            }
          }
          completion(result)
        }
      }
    } else {
      completion(nil)
    }
  }
    
    func checkUserLikes(id:String) -> Bool{
        return currUser!.posts_liked.contains(id)
    }
  
  
    func addFriend(friend: User, completion: @escaping (Bool) -> Void) {
        let user_ref = getUserById(id: currUser!.id)
        let friend_ref = getUserById(id: friend.id)
        if user_ref != nil && friend_ref != nil {
            user_ref!.updateData([
                "friends": FieldValue.arrayUnion([friend_ref!])
            ])
            friend_ref!.updateData([
                "friends": FieldValue.arrayUnion([user_ref!])
            ])
            if let index = self.users.firstIndex(where: { $0.id == currUser!.id }) {
                self.users[index].friends.append(friend_ref!)
            }
            if let index = self.users.firstIndex(where: { $0.id == friend.id }) {
                self.users[index].friends.append(user_ref!)
            }
            
            self.friends.append(friend)
            completion(true)
        } else {
            print("User or friend does not exist")
            completion(false)
        }
    }
  
    func removeFriend(friend: User, completion: @escaping (Bool) -> Void) {
        let user_ref = getUserById(id: currUser!.id)
        let friend_ref = getUserById(id: friend.id)
        if user_ref != nil && friend_ref != nil {
            user_ref!.updateData([
                "friends": FieldValue.arrayRemove([friend_ref!])
            ])
            friend_ref!.updateData([
                "friends": FieldValue.arrayRemove([user_ref!])
            ])
            
            if let index = self.users.firstIndex(where: { $0.id == currUser!.id }) {
                self.users[index].friends = self.users[index].friends.filter{$0 != friend_ref!}
            }
            if let index = self.users.firstIndex(where: { $0.id == friend.id }) {
                self.users[index].friends = self.users[index].friends.filter{$0 != user_ref!}
            }
            
            self.friends = self.friends.filter{$0.id != friend.id}
            
            completion(true)
        } else {
            print("User or friend does not exist")
            completion(false)
        }
    }
  
    func checkFriendStatus(user: User, possibleFriend: User) -> Bool {
      for f in user.friends {
          if f.documentID == possibleFriend.id {
            return true
          }
      }
      return false
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
