//
//  Created by Jeans Ruiz on 4/09/23.
//

import Foundation
import SwiftUI

struct TestingAsyncStreamView: View {

  var model = TestingAsyncStreamModel()

  var body: some View {
    Form {
      Section {
        Text("What if you take 5 ScreenShots?")
        .padding()

        if let messageCounter = model.messageCounter {
          Text(messageCounter)
        }

        if let message = model.message {
          Text("\(message)")
        }
      }
      .padding([.top])
    }
    .onDisappear {
      model.onDisappear()
    }
    .task {
      await model.onTask()
    }
  }
}

@Observable class TestingAsyncStreamModel {
  var message: String?
  var messageCounter: String?
  private var counter: Int = 0

  func onTask() async {
    for await _ in await NotificationCenter.default.notifications(named: UIApplication.userDidTakeScreenshotNotification) {
      counter += 1
      validateCounter(counter)
    }
  }

  func onDisappear() {
    message = nil
    messageCounter = nil
    counter = 0
  }

  /// Check the tests associated to this model
  private func validateCounter(_ counter: Int) {
    if counter == 1 {
      messageCounter = "You took 1 snapshot so far"
    } else {
      messageCounter = "You already took \(counter) snapshots so far"

      if counter >= 5 {
        message = "Why are you taking to many screenshots?"
      }
    }
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  TestingAsyncStreamView()
}
