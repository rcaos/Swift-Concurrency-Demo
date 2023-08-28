//
//  Created by Jeans Ruiz on 28/08/23.
//

import Foundation
import SwiftUI

struct AsyncLetTasksView: View {

  var model = AsyncLetTasksModel()

  var body: some View {
    Form {
      Section {
        Button("Run Two Tasks in Parallel! \nGet Random User AND \na Random Factor about a number", action: {
          Task {
            await model.run()
          }
        })
        .padding()

        if model.state.isRequesting {
          HStack {
            Spacer()
            ProgressView()
              .id(UUID())
            Spacer()
          }
        }
      }
      .padding([.top])

      if let user = model.state.user {
        Section(content: {
          Text("📝 Name: \(user.name)")
          Text("📩 Email: \(user.email)")
        }, header: {
          Text("Random User:")
        })
      }

      if let fact = model.state.fact {
        Section(content: {
          Text("Fact abour the number: \(fact.number)")
          Text(fact.description)
        }, header: {
          Text("Random Fact:")
        })
      }

      Spacer()
    }
    .onDisappear {
      model.onDisappear()
    }
  }
}

struct AsyncLetModel {
  var user: User?
  var fact: Fact?
  var isRequesting = false

  mutating func reset() {
    user = nil
    fact = nil
    isRequesting = false
  }
}

@Observable class AsyncLetTasksModel {
  var state = AsyncLetModel()

  func run() async {
    state.isRequesting = true

    async let user = fetchRandomUser()
    async let fact = getNumberFact(Int.random(in: 1...200))

    // 🚨 The two request are running in parallel
//    state.user = await user
//
////    do {
////      try await Task.sleep(for: .seconds(2))
////    } catch {
////    }
//    // Si llego aquí si reenderiza
//
//    state.fact = await fact

    state.fact = await fact
    state.user = await user

    state.isRequesting = false
  }

  func onDisappear() {
    state.reset()
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  AsyncLetTasksView()
}
