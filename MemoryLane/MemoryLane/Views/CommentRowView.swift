//
//  CommentRowView.swift
//  MemoryLane
//
//  Created by Hanna Luo on 12/6/23.
//

import Foundation
import SwiftUI

struct CommentRowView: View {
  var comment : Comment
  @State var username = ""
  
  var body: some View {
    HStack{
      Text(username)
      Text(":")
      Text(comment.text).foregroundColor(Color.black)
    }.onAppear{getUsername()}
  }
  
  private func getUsername() {
      username = dbDocuments.getUserName(user_id: comment.user_id) ?? "username not found"
  }
}
