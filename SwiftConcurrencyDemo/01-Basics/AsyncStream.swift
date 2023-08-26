//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation
import SwiftUI

struct AsyncStream02: View {

  var model = AsyncStream02Model()

  var body: some View {
    Form {
      Section {
        Text("Throws an error for multiples of 11:")
        Text("Last generated number: \(model.lastRandomValue)")
      }
    }
    .task {
      await model.doTask()
    }
    .onDisappear(perform: {
      model.onDisappear()
    })
  }
}

@Observable class AsyncStream02Model {
  var lastRandomValue: Int = 0
  private var task: Task<(), Never>?

  func doTask() async {
    task = Task {
      do {
        for try await random in randomGenerator() {
          print(random)
          lastRandomValue = random
        }
      } catch  {
        print(error)
      }
    }
  }

  func onDisappear() {
    task?.cancel()
    task = nil
    lastRandomValue = 0
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

private func randomGenerator() -> AsyncThrowingStream<Int, Error> {
  struct RandomGeneratorError: Error { }

  /// let stream = AsyncThrowingStream<Int, Error> {
  /// }
  return AsyncThrowingStream(unfolding: {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    let generated = Int.random(in: 1...1000)
    if generated % 11 == 0 {
      throw RandomGeneratorError()
    }
    return generated
  })
}

#Preview {
  AsyncStream02()
    .preferredColorScheme(.dark)
}
