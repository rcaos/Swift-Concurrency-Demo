//
//  Created by Jeans Ruiz on 1/09/23.
//

import Foundation
import SwiftUI

struct TestingDemoView: View {

  @Bindable var model = TestingDemoModel(fetchRandomUser: .init())

  var body: some View {
    Form {
      Section {
        HStack {
          if model.isRequestingUser {
            Button("Cancel", action: {
              model.cancel()
            })
            Spacer()
            ProgressView()
              .id(UUID())
          } else {
            Button("👉 Get Random User", action: {
              Task {
                await model.getRandomUser()
              }
            })
          }
        }
        .padding()

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

@Observable class TestingDemoModel {
  var user: User?
  var isRequestingUser = false
  var showError = false
  private var userTask: Task<Void, Never>?

  private let fetchRandomUser: FetchRandomUser

  init(fetchRandomUser: FetchRandomUser) {
    self.fetchRandomUser = fetchRandomUser
  }

  func getRandomUser() async {
    user = nil
    isRequestingUser = true

    userTask = Task {
      do {
        user = try await fetchRandomUser.execute(request: .init(sleep: 1))
      } catch {
        if !Task.isCancelled {
          showError = true
        }
      }
      isRequestingUser = false
    }
  }

  func cancel() {
    userTask?.cancel()
    userTask = nil
    user = nil
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  TestingDemoView()
}
