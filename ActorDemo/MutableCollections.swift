//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

public class MutableCollections {

  // When a variable is declared as var it becomes mutable and
  // not thread-safe unless the data type is specifically designed to be thread-safe when mutable.
  //
  // Swift collection types such as Array and Dictionary are not thread-safe when they’re mutable.
  //

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
