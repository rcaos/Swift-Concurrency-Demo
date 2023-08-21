//
//  Created by Jeans Ruiz on 21/08/23.
//

import Foundation

public let _XCTIsTesting: Bool = {
  ProcessInfo.processInfo.environment.keys.contains("XCTestBundlePath")
  || ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath")
  || ProcessInfo.processInfo.environment.keys.contains("XCTestSessionIdentifier")
  || (ProcessInfo.processInfo.arguments.first
    .flatMap(URL.init(fileURLWithPath:))
    .map { $0.lastPathComponent == "xctest" || $0.pathExtension == "xctest" }
      ?? false)
}()
