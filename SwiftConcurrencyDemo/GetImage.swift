//
//  Created by Jeans Ruiz on 30/08/23.
//

import Foundation

func getImage(_ url: String) async throws -> Data {
  print("🖼️ Start download image")
  do {
    let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
    return data
  } catch  {
    print("🖼️ Error downloading image: \(error.localizedDescription)")
    throw error
  }
}

//print("Bytes: \(ByteCountFormatter().string(fromByteCount: Int64(data.count)))")
