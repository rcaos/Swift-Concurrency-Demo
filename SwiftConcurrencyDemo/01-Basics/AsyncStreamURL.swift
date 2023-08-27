//
//  Created by Jeans Ruiz on 26/08/23.
//

import Foundation
import SwiftUI

struct AsyncStreamURLView: View {
  var model = AsyncStreamURLModel()

  var body: some View {
    Form {
      Section {
        Button("Download large Image", action: {
          model.download()
        })
        if model.state.isLoading {
          ProgressView().id(UUID())
        }
        Text("Progress: \(String(format: "%.2f", model.state.progressValue)) %")

        if let total = model.state.totalDownloaded {
          Text("Total Downloaded: \(total)")
        }
      }
    }
    .onAppear {
      model.onAppear()
    }
    .onDisappear {
      model.onDisappear()
    }
  }
}

struct AsyncStreamURLState {
  var progressValue: Double = 0
  var isLoading = false
  var totalDownloaded: String?

  mutating func reset() {
    progressValue = 0
    isLoading = false
    totalDownloaded = nil
  }
}

@Observable class AsyncStreamURLModel {
  var state = AsyncStreamURLState()

  private let downloadService = DownloadService()
  private var task: Task<(), Never>?

  func download() {
    state.reset()

    task = Task {
      do {
        state.isLoading = true
        let url = URL(string: "https://source.unsplash.com/random/4000x4000")!
        for try await progress in try await downloadService.download(url) {
          switch progress {
          case .loading(let value):
            state.progressValue = round(value * 100)
          case .completed(let data):
            state.isLoading = false
            state.totalDownloaded = ByteCountFormatter().string(fromByteCount: Int64(data.count))
          }
        }
      } catch  {
        state.reset()
        print(error)
      }
    }
  }

  func onAppear() {
    state.reset()
  }

  func onDisappear() {
    task?.cancel()
    task = nil
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: DownloadService
final class DownloadService {

  private var observer: NSKeyValueObservation?

  struct DownloadError: Error { }

  init() { }

  func download(_ url: URL) async throws -> AsyncThrowingStream<DownloadProgress, Error> {
    return AsyncThrowingStream<DownloadProgress, Error> { continuation in

      continuation.onTermination = { b in
        print("Download stream finish")
      }

      let request = URLRequest(url: url)
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error != nil {
          continuation.finish(throwing: DownloadError())
        } else if let data {
          continuation.yield(.completed(data))
        } else {
          continuation.finish(throwing: DownloadError())
        }
      }

      self.observer = task.progress.observe(\.fractionCompleted) { progress, _ in
        continuation.yield(.loading(progress.fractionCompleted))
      }
      task.resume()
    }
  }

  deinit {
    print("Deinit: \(Self.self)")
  }
}

enum DownloadProgress {
  case loading(Double)
  case completed(Data)
}

#Preview {
  AsyncStreamURLView()
    .preferredColorScheme(.dark)
}
