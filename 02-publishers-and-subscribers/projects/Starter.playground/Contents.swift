import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Publisher") {
  let myNotification = Notification.Name("MyNotification")

  let publisher = NotificationCenter.default
    .publisher(for: myNotification, object: nil)

  let center = NotificationCenter.default

  let observer = center.addObserver(
    forName: myNotification,
    object: nil,
    queue: nil) { notification in
      print("Notification received!")
    }

  center.post(name: myNotification, object: nil)

  center.removeObserver(observer)
}

example(of: "Subscriber") {
  let myNotification = Notification.Name("MyNotification")
  let center = NotificationCenter.default

  let publisher = center.publisher(for: myNotification, object: nil)

  let subscription = publisher
    .sink { _ in
      print("completion")
    } receiveValue: { _ in
      print("Notification received from a publisher!")
    }

  center.post(name: myNotification, object: nil)

  subscription.cancel()

}

example(of: "Just") {
  let just = Just("Hello world!")

  _ = just
    .sink(receiveCompletion: {
      print("Received completion", $0)
    }, receiveValue: {
      print("Received value", $0)
    })

  _ = just
    .sink(
      receiveCompletion: {
        print("Received completion (another)", $0)
      },
      receiveValue: {
        print("Received value (another)", $0)
      })
}

example(of: "assign(to:on:)") {
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }

  let object = SomeObject()

  let publisher = ["Hello", "world!"].publisher

  _ = publisher
    .assign(to: \.value, on: object)
}

example(of: "assign(to:)") {
  class SomeObject {
    @Published var value = 0
  }

  let object = SomeObject()

  object.$value
    .sink {
      print($0)
    }

  (0..<10).publisher
    .assign(to: &object.$value)
}

example(of: "Custom Subscriber") {
  let publisher = (1...6).publisher
//  let publisher = ["A", "B", "C", "D", "E", "F"].publisher

  final class IntSubscriber: Subscriber {
    func receive(subscription: any Subscription) {
      subscription.request(.max(3))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received value", input)
      return .none
//      return .unlimited
//      return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
      print("Received completion", completion)
    }
    
    typealias Input = Int
    typealias Failure = Never
  }

  let subscriber = IntSubscriber()

  publisher.subscribe(subscriber)
}

example(of: "Future") {
  func futureIncrement(
    integer: Int,
    afterDelay delay: TimeInterval
  ) -> Future<Int, Never> {
    Future<Int, Never> { promise in
      print("Original")
      DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
        promise(.success(integer + 1))
      }
    }
  }

  let future = futureIncrement(integer: 1, afterDelay: 3)

  future
    .sink {
      print($0)
    } receiveValue: {
      print($0)
    }
    .store(in: &subscriptions)

  future
    .sink(receiveCompletion: { print("Second", $0) },
          receiveValue: { print("Second", $0) })
    .store(in: &subscriptions)

}

example(of: "PassthroughSubject") {
  enum MyError: Error {
    case test
  }

  final class StringSubscriber: Subscriber {
    func receive(subscription: any Subscription) {
      subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
      print("Received value", input)

      return input == "World" ? .max(1) : .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
      print("Received completion", completion)
    }
    
    typealias Input = String
    typealias Failure = MyError
  }

  let subscriber = StringSubscriber()

  let subject = PassthroughSubject<String, MyError>()

  subject.subscribe(subscriber)

  let subscription = subject
    .sink { completion in
      print("Received completion (sink)", completion)
    } receiveValue: { value in
      print("Received value (sink)", value)
    }

  subject.send("Hello")
  subject.send("World")

  subscription.cancel()

  subject.send("Still there?")

  subject.send(completion: .failure(MyError.test))
  subject.send(completion: .finished)
  subject.send("How about another one?")
}

example(of: "CurrentValueSubject") {
  var subscriptions = Set<AnyCancellable>()

  let subject = CurrentValueSubject<Int, Never>(0)

  subject
    .print()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)

  subject.send(1)
  subject.send(2)

  print(subject.value)

  subject.value = 3
  print(subject.value)

  subject
    .print()
    .sink(receiveValue: { print("Second subscription", $0) })
    .store(in: &subscriptions)

  subject.send(completion: .finished)
}

/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
