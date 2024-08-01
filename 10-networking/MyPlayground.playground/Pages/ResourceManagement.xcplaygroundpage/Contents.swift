//: [Previous](@previous)

import Foundation
import Combine

let shared = URLSession.shared
  .dataTaskPublisher(for: URL(string: "https://www.kodeco.com")!)
  .map(\.data)
  .print("shared")
  .share()

print("subscribing first")

let subscription1 = shared.sink(receiveCompletion: { _ in

}, receiveValue: {
  print("subscription1 received: '\($0)'")
})

//print("subscribing second")

//let subscription2 = shared.sink(receiveCompletion: { _ in
//
//}, receiveValue: {
//  print("subscription2 received: '\($0)'")
//})

var subscription2: AnyCancellable? = nil

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
  print("subscribing second")

  subscription2 = shared.sink(
    receiveCompletion: { print("subscription2 completion \($0)") },
    receiveValue: { print("subscription2 received: '\($0)'") }
  )
}

//: [Next](@next)
