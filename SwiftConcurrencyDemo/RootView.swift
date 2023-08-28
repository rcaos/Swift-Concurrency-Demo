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
        }, header: {
          Text("Getting Started")
        })

        Section(content: {
          NavigationLink("AsyncStream - Unfolding", destination: {
            AsyncStream02()
          })
          NavigationLink("AsyncStreamURL", destination: {
            AsyncStreamURLView()
          })
          NavigationLink("AsyncStream - Delegate", destination: {
            BasicsContinuationView()
          })
        } , header: {
          Text("Async Stream")
        })
      }
      .navigationTitle("Swift Concurrency")
    }
  }
}

#Preview {
  RootView()
}
