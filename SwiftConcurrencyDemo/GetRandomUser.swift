//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation

public func fetchRandomUser() async -> User? {
  do {
    let randomUserId = Int.random(in: 1...12)
    let url = URL(string: "https://reqres.in/api/users/\(randomUserId)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let response = try JSONDecoder().decode(RandomUserResponse.self, from: data)
    return response.toDomain()
  } catch {
    print("\(error.localizedDescription)")
    return nil
  }
}

private struct RandomUserResponse: Decodable {
  private let data: UserDTO

  private struct UserDTO: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String

    private enum CodingKeys: String, CodingKey {
      case id
      case firstName = "first_name"
      case lastName = "last_name"
      case email
    }
  }

  func toDomain() -> User {
    return .init(
      id: data.id,
      name: data.firstName + " " + data.lastName,
      email: data.email
    )
  }
}

public struct User {
  public let id: Int
  public let name: String
  public let email: String
}
