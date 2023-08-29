//
//  Created by Jeans Ruiz on 28/08/23.
//

import Foundation
import SwiftUI

struct AsyncLetTasksView: View {

  //var model = AsyncLetTasksModel()
  @Bindable var model = AsyncLetTasksModel()

  var body: some View {
    Form {
      Section {
        Button("Run Two Tasks! \nGet Random User AND \nGet a Random Factor about a number", action: {
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

struct AsyncLetModel {
  var user: User?
  var fact: Fact?
  var isRequesting = false
  var showAlert = false

  mutating func reset() {
    user = nil
    fact = nil
    isRequesting = false
    showAlert = false
  }
}

@Observable class AsyncLetTasksModel {
  var state = AsyncLetModel()

  func run() async {
    state.isRequesting = true

    // 🚨 Creates a Child Task, Immediately, runs the task and continues the flow
    async let user = fetchRandomUser()

    // 🚨 Creates a Child Task, Immediately, runs the task and continues the flow
    async let fact = getNumberFact(Int.random(in: 1...200))

    do {
      // A task parent-child link enforces a rule that says a parent task can only finish its work if all of its child tasks have finished
      // The tree is responsible to cancel other child tasks
      // If one Child Task throws an error, The other child Task is Cancelled
      let (responseFact, responseUser) = await (try fact, try user)
      state.fact = responseFact
      state.user = responseUser
    } catch {
      print("Error Model: \(error)")
      state.showAlert = true
    }

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
