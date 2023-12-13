//
//  CommentRowView.swift
//  MemoryLane
//
//  Created by Hanna Luo on 12/6/23.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct CommentRowView: View {
  var comment : Comment
  @State var username = ""
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(username)
        .font(.system(size: 15))
        Text("\(Helpers.formattedTime(time: comment.time))")
        .font(.system(size: 15))
        .foregroundColor(.taupe)
      Text(comment.text)
        .font(.system(size: 15))
    }
    .onAppear{getUsername()}
    .padding()
    .frame(width: 360, alignment: .leading)
  }
  
  private func getUsername() {
      username = dbDocuments.getUserName(user_id: comment.user_id) ?? "username not found"
  }
}
