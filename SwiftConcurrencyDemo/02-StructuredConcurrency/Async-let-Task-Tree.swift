//
//  Created by Jeans Ruiz on 30/08/23.
//

import SwiftUI

struct AsyncLetTaskTreeView: View {

  var model = AsyncLetTaskTreeModel()

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



@Observable class AsyncLetTaskTreeModel {
  var isRequesting = false

  var disposeTask: Task<Void, Never>?

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
      do {
        for (index, image) in images.enumerated() {

          try Task.checkCancellation() // Avoid keep iterating if the Task was cancelled, comment and see whats happens
          //if Task.isCancelled { break }

          let model = await getUser_Fact_and_Image(index, image)
          print("🔴 returned: \(String(describing: model))\n")
        }
      } catch {
        print("Error Array: \(error)")
      }
      isRequesting = false
    }
  }

  func onDisappear() {
    disposeTask?.cancel()
    disposeTask = nil

    isRequesting = false
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

#Preview {
  AsyncLetTaskTreeView()
}

// MARK: - Models
private struct RandomStuff {
  let url: String
  let user: User
  let fact: Fact
  let image: Data
}

private func getUser_Fact_and_Image(_ index: Int, _ url: String) async -> RandomStuff? {
  async let user = fetchRandomUser(sleep: 2)
  async let fact = getNumberFact(for: index, sleep: 2, forceError: index >= 3)
  async let imageGet = getImage(url)

  do {
    // If one of the child Task throw an error
    // The other child Tasks will cancel with Swift.CancellationError
    let (responseFact, responseUser, image) = await (try fact, try user, try imageGet)
    return .init(url: url, user: responseUser, fact: responseFact, image: image)
  }
  catch {
    print("Error in getUser_Fact_and_Image(): \(error.localizedDescription)")
    return nil
  }
}
