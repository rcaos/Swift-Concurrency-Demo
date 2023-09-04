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
          NavigationLink("Closures to Async", destination: {
            Basic02View()
          })
        }, header: {
          Text("Getting Started")
        })

        Section(content: {
          NavigationLink("Async-let Tasks", destination: {
            AsyncLetTasksView()
          })
          NavigationLink("Async-let Tasks - Cancellation", destination: {
            AsyncLetTasksCancellationView()
          })
          NavigationLink("Async-let Task Tree", destination: {
            AsyncLetTaskTreeView()
          })
          NavigationLink("Group Tasks", destination: {
            GroupTaskView()
          })
        }, header: {
          Text("Structured Concurrency")
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

        Section(content: {
          NavigationLink("Test Loading and Cancellation", destination: {
            TestingDemoView()
          })
          NavigationLink("Test Async Stream", destination: {
            TestingAsyncStreamView()
          })
        } , header: {
          Text("Testing")
        })
      }
      .navigationTitle("Swift Concurrency")
    }
  }
}

#Preview {
  RootView()
}
