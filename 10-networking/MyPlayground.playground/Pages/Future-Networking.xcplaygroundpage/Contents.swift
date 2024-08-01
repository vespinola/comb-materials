//: [Previous](@previous)

import Foundation
import Combine

func performSomeWork() throws -> Int {
  print("Performing some work and returning a result")
  return 5
}

let future = Future<Int, Error> { fulfill in
  do {
    let result = try performSomeWork()
    // 3
    fulfill(.success(result))
  } catch {
    // 4
    fulfill(.failure(error))
  }
}

print("Subscribing to future...")

// 5
let subscription1 = future
  .sink(
    receiveCompletion: { _ in print("subscription1 completed") },
    receiveValue: { print("subscription1 received: '\($0)'") }
  )

// 6
let subscription2 = future
  .sink(
    receiveCompletion: { _ in print("subscription2 completed") },
    receiveValue: { print("subscription2 received: '\($0)'") }
  )

//: [Next](@next)
