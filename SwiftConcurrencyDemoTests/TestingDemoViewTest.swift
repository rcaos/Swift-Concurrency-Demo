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
      //await Task.yield() /// It's mandatory?
      return .init(id: 1, name: "name", email: "aa@mail")
    })

    let sut = TestingDemoModel(fetchRandomUser: { mock })

    let task = Task {
      await sut.getRandomUser()
    }
    await Task.yield()
    XCTAssertTrue(sut.isRequestingUser)
    await sut.userTask?.value
    await task.value

    XCTAssertEqual(sut.user, .init(id: 1, name: "name", email: "aa@mail"))
    XCTAssertFalse(sut.isRequestingUser)
  }
}
