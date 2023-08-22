//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

import XCTest
import ActorDemo

final class ActorCollectionTests: XCTestCase {

  func test_Break_Dictionary() async throws {
    let sut = MutableCollectionActor()

    let expectedValue = 1000

    let tasks = (1...expectedValue).map { index in
      return Task(priority: .random) {
        try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )

        // The randomKey could repeat @@@
        await sut.increment(key: randomKey(), index)
      }
    }

    for task in tasks {
      try await task.value
    }

    let value = await sut.events.count
    XCTAssertEqual(value, expectedValue)
  }

  func test_Break_Dictionary_02() async throws {
    let expectedValue = 1000

    let sut = MutableCollectionActor()

    _ = try await withThrowingTaskGroup(of: Int.self) { group in
      for index in 1...expectedValue {
        group.addTask {
          try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
          await sut.increment(key: randomKey(), index)
          return index
        }
      }

      for try await result in group {
        _ = result
      }
    }

    let value = await sut.events.count
    XCTAssertEqual(value, expectedValue)
  }

  func test_Break_Array01() async throws {
    let sut = MutableCollectionActor()

    let expectedValue = 1000

    let tasks = (1...expectedValue).map { index in
      return Task(priority: .random) {
        try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )

        // The randomKey could repeat @@@
        await sut.add(index)
      }
    }

    for task in tasks {
      try await task.value
    }

    let value = await sut.arrayEvents.count
    XCTAssertEqual(value, expectedValue)
  }

  func test_Break_Array02() async throws {
    let expectedValue = 1000

    let sut = MutableCollectionActor()

    _ = try await withThrowingTaskGroup(of: Int.self) { group in
      for index in 1...expectedValue {
        group.addTask {
          try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
          await sut.add(index)
          return index
        }
      }

      for try await result in group {
        _ = result
      }
    }

    let value = await sut.arrayEvents.count
    XCTAssertEqual(value, expectedValue)
  }
}
