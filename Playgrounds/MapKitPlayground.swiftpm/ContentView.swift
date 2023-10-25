import SwiftUI
import MapKit
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            TextField("Search for a location", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(viewModel.searchResults, id: \.title) { result in
                Text(result.title)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
