//: [Previous](@previous)

import Combine
import Foundation

let url = URL(string: "https://www.kodeco.com")!

let publisher = URLSession.shared
  .dataTaskPublisher(for: url)
  .map(\.data)
  .multicast { PassthroughSubject<Data, URLError>() }

let subscription1 = publisher
  .sink(receiveCompletion: { completion in
    if case .failure(let err) = completion {
      print("Sink1 Retrieving data failed with error \(err)")
    }
  }, receiveValue: { object in
    print("Sink1 Retrieved object \(object)")
  })

// 3
let subscription2 = publisher
  .sink(receiveCompletion: { completion in
    if case .failure(let err) = completion {
      print("Sink2 Retrieving data failed with error \(err)")
    }
  }, receiveValue: { object in
    print("Sink2 Retrieved object \(object)")
  })

let subscription = publisher.connect()

//: [Next](@next)
