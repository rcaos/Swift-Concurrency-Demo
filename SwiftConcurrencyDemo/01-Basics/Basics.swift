//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation
import SwiftUI

struct Basics01: View {

  //var model = Basics01Model()
  @Bindable var model = Basics01Model() // It's necessary to use the Alert? isPresented: $model.showError

  var body: some View {
    Form {
      Section {
        Button("👉 Get Random User", action: {
          Task {
            await model.getRandomUser()
          }
        })
        .padding()

        if model.isRequestingUser {
          ProgressView()
            .id(UUID())
        }

        if let user = model.user {
          Text("📝 Name: \(user.name)")
          Text("📩 Email: \(user.email)")
        }
      }
      .padding([.top])

      Spacer()
    }
    .alert("Error to Fetch User", isPresented: $model.showError) {
      Button("OK", action: { })
    }
  }
}

@Observable class Basics01Model {
  var user: User?
  var isRequestingUser = false
  var showError = false

  func getRandomUser() async {
    isRequestingUser = true
    do {
      user = try await fetchRandomUser()
    } catch {
      showError = true
    }

    isRequestingUser = false
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  Basics01()
}
