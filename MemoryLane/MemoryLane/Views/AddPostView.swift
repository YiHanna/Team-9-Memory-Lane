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
    var showPrompt : Bool
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = nil
  
    @State var description: String = ""
    @State var selectedDate = Date()
    
    @ObservedObject var viewModel = LocationViewModel()
    
    @State private var isPostCreated = false
    @State private var isPopoverPresented = false

    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var displayImage: Image? {
      if let picture = image {
        return Image(uiImage: picture)
      } else {
        return nil
      }
    }
  
  var body: some View {
    NavigationView{
      ScrollView {
        ZStack {
          VStack{
            if showPrompt{
              if let p = dbDocuments.currPrompt{
                Text(p.text)
              }
            }
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
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                .zIndex(1)
                .frame(minHeight: minRowHeight * 10)
              }
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
            NavigationLink("", destination: HomeView(dbDocuments: dbDocuments), isActive: $isPostCreated)
          )
        }.navigationBarBackButtonHidden(false)
      }
    }
  }
        
    
    private func createPost(){
        var data : [String: Any] = [
            "date": Timestamp(date: selectedDate),
            "description": description,
            "num_likes": 0,
        ]
         
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
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView(showPrompt: false)
    }
}
