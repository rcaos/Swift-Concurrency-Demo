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
