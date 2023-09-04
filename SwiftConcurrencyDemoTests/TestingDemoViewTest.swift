//
//  Created by Jeans Ruiz on 1/09/23.
//

import XCTest
import ConcurrencyExtras
@testable import SwiftConcurrencyDemo

final class TestingDemoViewTest: XCTestCase {

  override func invokeTest() {
    withMainSerialExecutor {
      super.invokeTest()
    }
  }

  func testExample() async {
    let mock = FetchRandomUser(execute: { request in
      // 0. It's necessary this yield?
      //await Task.yield()
      return .init(id: 1, name: "name", email: "aa@mail")
    })

    let sut = TestingDemoModel(fetchRandomUser: { mock })

    // 1. Wrap into a Task
    let task = Task {
      await sut.getRandomUser()
    }

    // 2. Wait for it
    await Task.yield()

    // 3. Check condition Before run Task
    XCTAssertTrue(sut.isRequestingUser)

    // 4. Optional, in this case because I'm handling cancellation
    await sut.userTask?.value

    // 5. Wait for task result
    await task.value

    // 6. Assert for expected results
    XCTAssertEqual(sut.user, .init(id: 1, name: "name", email: "aa@mail"))
    XCTAssertFalse(sut.isRequestingUser)
  }
}
