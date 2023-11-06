//
//  AddPost.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

import Firebase
import FirebaseFirestore

struct AddPostView: View {
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = nil
  
    @State var description: String = ""
    @State var selectedDate = Date()
    
    @ObservedObject var viewModel = ViewModel()
    
    @State private var isPostCreated = false
    
    var displayImage: Image? {
      if let picture = image {
        return Image(uiImage: picture)
      } else {
        return nil
      }
    }
  
    var body: some View {
        NavigationView{
            VStack{
                displayImage?.resizable().scaledToFit().padding()
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Text("Add Picture")
                }.padding()
                VStack {
                    Text("Description (max: 250 characters):")
                        .fontWeight(.bold)
                        .padding(.trailing)
                    TextField("Add a caption", text: $description)
                        .padding(.trailing)
                }.padding()
                VStack {
                    Text("Date:")
                        .fontWeight(.bold)
                        .padding(.trailing)
                    DatePicker("Add a month and year", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                }.padding()
                VStack {
                    TextField("Search for a location", text: $viewModel.searchQuery)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if viewModel.showLocationResults {
                        List(viewModel.searchResults, id: \.title) { result in
                            Text(result.title).onTapGesture {
                                viewModel.selectLocation(result)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $showImagePicker) {
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
            }
            .navigationBarTitle("New Memory")
            .navigationBarItems(trailing:
                Button(action: {
                    createPost()
                    isPostCreated = true
                }) {
                    Text("Post")
                }
            )
            .background(
                NavigationLink("", destination: HomeView(), isActive: $isPostCreated)
            )
        }.navigationBarBackButtonHidden(true)
    }
        
    
    private func createPost(){
        var data : [String: Any] = [
            "date": Timestamp(date: selectedDate),
            "description": description,
            "num_likes": 0
        ]
        
        if let user = dbDocuments.currUser {
            data["user_id"] = user
            
            viewModel.getGeoPoint(){ geoPoint in
                data["location"] = geoPoint
                
                if let img = image {
                    dbDocuments.uploadImage(img) { (url) in
                        if let imageURL = url {
                            data["photo"] = imageURL.absoluteString
                            print("Image URL: \(imageURL.absoluteString)")
                        } else {
                            print("Failed to upload the image.")
                        }
//                        print("data dict before creating post:")
//                        print(data)
                        
                        dbDocuments.createPost(data: data)
                    }
                }else{
                    print("creating post without picture")
                    dbDocuments.createPost(data: data)
                }
            }
        }else{
            print("Failed to create post - user does not exist")
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}