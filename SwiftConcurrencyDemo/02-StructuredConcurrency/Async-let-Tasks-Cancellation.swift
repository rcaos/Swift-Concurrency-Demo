//
//  Created by Jeans Ruiz on 29/08/23.
//

import Foundation
import SwiftUI

struct AsyncLetTasksCancellationView: View {

  //var model = AsyncLetTasksModel()
  @Bindable var model = AsyncLetTasksCancellationModel()

  var body: some View {
    Form {
      Section {
        Button("Run Two Tasks! but Go Back quickly to cancell the tasks \n\nGet Random User AND \nGet a Random Factor about a number", action: {
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
    .alert("Error to Fetch Data", isPresented: $model.state.showAlert) {
      Button("OK") { }
    }
  }
}

@Observable class AsyncLetTasksCancellationModel {
  var state = AsyncLetModel()

  var disposeTask: Task<Void, Never>?

  func run() async {
    state.isRequesting = true

    disposeTask = Task {
      async let user = fetchRandomUser()
      async let fact = getNumberFact(Int.random(in: 1...200))

      do {
        let (responseFact, responseUser) = await (try fact, try user)
        state.fact = responseFact
        state.user = responseUser
      } catch {
        print("Error Model: \(error)")
        if Task.isCancelled == false {
          state.showAlert = true
        }
      }
      state.isRequesting = false
    }
  }

  func onDisappear() {
    // This guarantees that the TWO child tasks will cancel
    // And will throw a CancellationError
    disposeTask?.cancel()
    disposeTask = nil
    state.reset()
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  AsyncLetTasksView()
}

