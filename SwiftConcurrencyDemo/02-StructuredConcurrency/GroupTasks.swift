//
//  Created by Jeans Ruiz on 31/08/23.
//

import SwiftUI

struct GroupTaskView: View {

  var model = GroupTaskModel()

  var body: some View {
    Form {
      Section {
        Button("Run Heavy Async Task. Go Back quickly to cancell them", action: {
          model.run()
        })
        .padding()

        if model.isRequesting {
          HStack {
            Spacer()
            ProgressView()
              .id(UUID())
            Spacer()
          }
        }
      }
      .padding([.top])

      Spacer()
    }
    .onDisappear {
      model.onDisappear()
    }
  }
}

@Observable class GroupTaskModel {
  var isRequesting = false
  var disposeTask: Task<Void, Never>?

  //private var response: [Int: RandomStuff] = [:]
  private var response: [RandomStuff] = []

  private var images =  [
    "https://source.unsplash.com/random/4000x4000",
    "https://d2pn8kiwq2w21t.cloudfront.net/original_images/PIA25985.jpg",
    "https://source.unsplash.com/random/3000x3000",
    "https://d2pn8kiwq2w21t.cloudfront.net/original_images/PIA25138.jpg",
    "https://source.unsplash.com/random/2000x2000",
    "https://d2pn8kiwq2w21t.cloudfront.net/original_images/PIA25983.jpg",
    "https://source.unsplash.com/random/1000x1000"
  ]

  func run() {
    isRequesting = true

    disposeTask = Task {
      self.response = await getStuffs()
    }
  }

  private func getStuffs() async -> [RandomStuff] {
    var randomStuff: [RandomStuff] = []

    do {
      try await withThrowingTaskGroup(of: RandomStuff.self) { group in
        for (index, imageURL) in images.enumerated() {
          group.addTask { ///group.addTask(priority: .background) {
            return try await getUser_Fact_and_Image(index + 1, imageURL)
          }
        }

        for try await model in group {
          randomStuff.append(model)
        }
      }
    } catch {
      print("Error Group: \(error)")
    }
    isRequesting = false
    return randomStuff
  }

  func onDisappear() {
    disposeTask?.cancel()
    disposeTask = nil
    response.removeAll()

    isRequesting = false
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  GroupTaskView()
}

// MARK: - Models
private struct RandomStuff {
  let url: String
  let user: User
  let fact: Fact
  let image: Data
}

private func getUser_Fact_and_Image(_ index: Int, _ url: String) async throws -> RandomStuff {
  print("⏳ index: \(index), url: \(url)")

  let sleep: Int?
  switch index {
  case 1:
    sleep = 4
  case 2:
    sleep = 3
  case 3:
    sleep = 2
  default:
    sleep = nil
  }

  async let user = fetchRandomUser(userId: index, sleep: sleep)
  async let fact = getNumberFact(for: index)
  async let imageGet = getImage(url)

  do {
    // If one of the child Task throw an error
    // The other child Tasks will cancel with Swift.CancellationError
    let (responseFact, responseUser, image) = await (try fact, try user, try imageGet)
    let model =  RandomStuff(url: url, user: responseUser, fact: responseFact, image: image)
    print("⏳ model: \(model)\n------------------------------------")
    return model
  }
  catch {
    print("Error in getUser_Fact_and_Image(): \(error.localizedDescription)")
    throw error
  }
}
