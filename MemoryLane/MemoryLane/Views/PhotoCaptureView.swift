//
//  PhotoCaptureView.swift
//  MemoryLane
//
//  Created by Cindy Chen on 11/2/23.
//

import SwiftUI

struct PhotoCaptureView: View {

  @Binding var showImagePicker: Bool
  @Binding var image: UIImage?

  var body: some View {
    ImagePicker(isShown: $showImagePicker, image: $image)
  }
}

