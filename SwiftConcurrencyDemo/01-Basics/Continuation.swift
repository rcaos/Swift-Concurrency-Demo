//
//  Created by Jeans Ruiz on 28/08/23.
//

import Foundation
import SwiftUI
import NotificationCenter

struct BasicsContinuationView: View {

  var model = BasicsContinuationModel()

  var body: some View {
    Form {
      Section {
        Button("📲 Go to background or \n 📸Take an Screenshot ", action: { })
        .padding()

        Text("Go to background event count: \(model.state.backgroundNotificiationsCount)")
        Text("Screenshots taken count: \(model.state.snapshotNotificationsCount)")

      }
      .padding([.top])

      Spacer()
    }
    .onAppear {
      model.onAppear()
    }
    .onDisappear {
      model.onDisappear()
    }
  }
}

// MARK: - Model
@Observable class BasicsContinuationModel {

  var state = BasicsContinuationModelState()

  private let subscriptionSender = NotificationsSender()

  private var disposeTask: Task<Void, Never>?

  func onAppear() {
    disposeTask = Task {
      for await event in subscriptionSender.subscribeToStream() {
        switch event {
        case .didGoesToBackground:
          state.backgroundNotificiationsCount += 1
        case .didTakeASnapshot:
          state.snapshotNotificationsCount += 1
        }
      }
    }
  }

  func onDisappear() {
    disposeTask?.cancel()
    disposeTask = nil
    state.reset()
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

struct BasicsContinuationModelState {
  var backgroundNotificiationsCount = 0
  var snapshotNotificationsCount = 0

  mutating func reset() {
    backgroundNotificiationsCount = 0
    snapshotNotificationsCount = 0
  }
}


// MARK: - A Delegate based component
import Combine

protocol NotificationsSenderDelegate {
  func didChangeNotifications(event: NotificationEvent)
}

enum NotificationEvent {
  case didGoesToBackground
  case didTakeASnapshot
}

class NotificationsSender {

  private var disposeBag = Set<AnyCancellable>()

  // You can't remove it yet, because is used for others components
  var delegate: NotificationsSenderDelegate?

  // Step 1, Declare continuation
  private var notificationStream: AsyncStream<NotificationEvent>.Continuation?

  init() {
    subscribe()
  }

  private func subscribe() {
    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.delegate?.didChangeNotifications(event: .didGoesToBackground)

        // Step 3, Send events using yield
        self?.notificationStream?.yield(.didGoesToBackground)
      })
      .store(in: &disposeBag)

    NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.delegate?.didChangeNotifications(event: .didTakeASnapshot)

        // Step 3, Send events using yield
        self?.notificationStream?.yield(.didTakeASnapshot)
      })
      .store(in: &disposeBag)
  }

  // Step 2: Expose a way to use this AsyncStream
  // Every time you called it, creates a new Stream
  func subscribeToStream() -> AsyncStream<NotificationEvent> {
    return AsyncStream { continuation in

      continuation.onTermination = { _ in
        self.notificationStream = nil
        print("FInished it here")
      }

      self.notificationStream = continuation
    }
  }

  // Step 4: Another way of expose a Stream
  // But how about when the Stream finish?
  // You need a way of Create it again
  lazy var streamTwo: AsyncStream<NotificationEvent> = {
    AsyncStream { continuation in
      self.notificationStream = continuation

      continuation.onTermination = { _ in
        print("FInished it Two here")
      }
    }
  }()
}

#Preview {
  BasicsContinuationView()
}
