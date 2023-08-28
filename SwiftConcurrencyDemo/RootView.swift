//
//  Created by Jeans Ruiz on 21/08/23.
//

import SwiftUI

struct RootView: View {

  var body: some View {
    NavigationStack {
      Form {
        Section(content: {
          NavigationLink("Basic", destination: {
            Basics01()
          })
          NavigationLink("Basic 02", destination: {
            Basic02View()
          })
          NavigationLink("Basic - Delegate", destination: {
            BasicsContinuationView()
          })
          NavigationLink("AsyncStream", destination: {
            AsyncStream02()
          })
          NavigationLink("AsyncStreamURL", destination: {
            AsyncStreamURLView()
          })
        }, header: {
          Text("Getting Started")
        })
      }
      .navigationTitle("Swift Concurrency")
    }
  }
}

#Preview {
  RootView()
}
