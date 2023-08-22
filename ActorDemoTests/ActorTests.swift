//
//  Created by Jeans Ruiz on 22/08/23.
//

import XCTest
import ActorDemo

final class ActorTests: XCTestCase {

  func testCounter() async throws {
    let sut = MutableActor()

    let expectedValue = 1000

    let tasks = (1...expectedValue).map { index in
      return Task(priority: .random) {
        try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
        try await sut.increment(index)
      }
    }

    for task in tasks {
      try await task.value
    }

    let value = await sut.counter
    XCTAssertEqual(value, expectedValue)
  }

  func testGroupTask() async throws {
    let expectedValue = 1000

    let sut = MutableActor()

    _ = await withThrowingTaskGroup(of: Int.self) { group in
      for index in 1...expectedValue {
        group.addTask {
          try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
          try await sut.increment(index)
          return index
        }
      }
    }

    let value = await sut.counter
    XCTAssertEqual(value, expectedValue)
  }

}
