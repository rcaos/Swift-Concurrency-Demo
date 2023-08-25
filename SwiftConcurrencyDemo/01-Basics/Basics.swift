//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation
import SwiftUI

struct Basics01: View {

  var model = Basics01Model()

  var body: some View {
    Section {
      Button("👉 Get Random User", action: {
        Task {
          await model.getRandomUser()
        }
      })
      .padding()

      if model.isRequestingUser {
        ProgressView()
      }

      if let user = model.user {
        Text("📝 Name: \(user.name)")
        Text("📩 Email: \(user.email)")
      }
    }
    .padding([.top])

    Spacer()
  }
}

@Observable class Basics01Model {
  var user: User?
  var isRequestingUser = false

  func getRandomUser() async {
    isRequestingUser = true
    user = await fetchRandomUser()
    isRequestingUser = false
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  Basics01()
}
