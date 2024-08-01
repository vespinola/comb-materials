//: [Previous](@previous)

import Foundation
import Combine

/*
 In Chapter 9, “Networking,” you used multicast(_:). This operator builds on share() and uses a Subject of your choice to publish values to subscribers. The unique characteristic of multicast(_:) is that the publisher it returns is a ConnectablePublisher. What this means is it won’t subscribe to the upstream publisher until you call its connect() method. This leaves you ample time to set up all the subscribers you need before letting it connect to the upstream publisher and start the work.
 */

let subject = PassthroughSubject<Data, URLError>()

let multicasted = URLSession.shared
  .dataTaskPublisher(for: URL(string: "https://www.kodeco.com")!)
  .map(\.data)
  .print("multicast")
  .multicast(subject: subject)

let subscription1 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription1 received: '\($0)'") }
  )

let subscription2 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription2 received: '\($0)'") }
  )

let cancellable = multicasted.connect()

//: [Next](@next)
