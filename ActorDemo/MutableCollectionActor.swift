//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

public actor MutableCollectionActor {

  // Compared with class ``MutableCollections``, this collections are Thread-safe

  public var events: [String: Any] = [:]
  public var arrayEvents: [Any] = []

  public init() { }

  public func increment(key: String, _ index: Int) {
    events[key] = index
  }

  public func add(_ index: Int) {
    arrayEvents.append(index)
  }
}
