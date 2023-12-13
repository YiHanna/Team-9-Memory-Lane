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
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var displayImage: Image? {
    if let picture = image {
      return Image(uiImage: picture)
    } else {
      return nil
    }
  }
  
  var btnBack: some View {
    Button(action: {
      presentationMode.wrappedValue.dismiss()
    }) {
      Image(systemName: "chevron.backward")
        .foregroundColor(Color.brown)
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        ZStack {
          VStack{
            if showPrompt{
              if let p = dbDocuments.currPrompt{
                Text(p.text)
              }
            }
            displayImage?.resizable().scaledToFit().padding()
            
            HStack {
              Button(action: {
                self.showImagePicker = true
              }) {
                Text("Add Picture")
                  .padding()
                  .background(Color.taupe)
                  .foregroundColor(.white)
                  .cornerRadius(10)
              }
              .padding()
              
              Spacer()
            }
            
            VStack {
              Text("Description (up to 250 characters)")
                .fontWeight(.bold)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField("Add a caption", text: $description)
                .foregroundColor(Color.taupe)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .leading)
            }.padding()
            
            VStack {
              Text("Date")
                .fontWeight(.bold)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .leading)
                
              DatePicker("Select an approximate date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .foregroundColor(.taupe)
                .datePickerStyle(DefaultDatePickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            }.padding()
            
            VStack {
              Text("Location")
                .fontWeight(.bold)
                .padding([.leading, .trailing])
                .frame(maxWidth: .infinity, alignment: .leading)
              
              TextField("Search for a location", text: $viewModel.searchQuery)
                .padding([.leading, .trailing])
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
          .background(
            NavigationLink("", destination: HomeView(dbDocuments: dbDocuments), isActive: $isPostCreated)
          )
        }
      }
    }
    .navigationBarTitle("New Memory", displayMode: .inline)
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: btnBack,
      trailing:
        Button(action: {
            createPost()
            isPostCreated = true
        }) {
          Text("Post")
            .foregroundColor(Color.brown)
        }
    )
  }
        
    
  private func createPost(){
      var data : [String: Any] = [
          "date": Timestamp(date: selectedDate),
          "description": description,
          "num_likes": 0,
      ]
       
      viewModel.getGeoPoint(searchQuery: viewModel.searchQuery){ geoPoint in
          data["location"] = geoPoint
          
          if let img = image {
              dbDocuments.uploadImage(img) { (url) in
                  if let imageURL = url {
                      data["photo"] = imageURL.absoluteString
                      print("Image URL: \(imageURL.absoluteString)")
                  } else {
                      print("Failed to upload the image.")
                  }
                  dbDocuments.createPost(data: data)
              }
          }else{
              print("creating post without picture")
              dbDocuments.createPost(data: data)
          }
      }
  }
}
