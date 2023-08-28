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
        Text("Throws an error for multiples of 5:")
        Text("Last generated number: \(model.lastRandomValue)")
      }

      if let error = model.randomError {
        Section {
          Text(error.description)
        }
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

// MARK: - Model
@Observable class AsyncStream02Model {
  var lastRandomValue: Int = 0
  var randomError: RandomGeneratorError?

  private var task: Task<(), Never>?

  func doTask() async {
    task = Task {
      do {
        for try await random in randomGenerator() {
          print(random)
          lastRandomValue = random
        }
      } catch let error as RandomGeneratorError {
        randomError = error
      } catch {
        print("A serious error: \(error.localizedDescription)")
      }
    }
  }

  func onDisappear() {
    task?.cancel()
    task = nil
    lastRandomValue = 0
    randomError = nil
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Generator
struct RandomGeneratorError: Error {
  let description: String
}

private func randomGenerator() -> AsyncThrowingStream<Int, Error> {
  /// let stream = AsyncThrowingStream<Int, Error> {
  /// }

  /// The simplest way to build an Async Stream
  /// But is the most limited
  return AsyncThrowingStream(unfolding: {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    let generated = Int.random(in: 1...1000)
    if generated % 5 == 0 {
      throw RandomGeneratorError(description: "An error found, Generator returned \(generated)")
    }
    return generated
  })
}

#Preview {
  AsyncStream02()
    .preferredColorScheme(.dark)
}
