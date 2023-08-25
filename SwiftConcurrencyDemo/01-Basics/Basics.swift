//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation
import SwiftUI

struct Basics01: View {

  @State var model = Basics01Model()

  var body: some View {
    Section {
      Button("👉 Get Random User", action: {
        Task {
          await model.toTask()
        }
      })
      .padding()

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

  func toTask() async {
    user = await getRandomUser()
  }
}

#Preview {
  Basics01()
}
