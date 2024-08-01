//: [Previous](@previous)

import Foundation

let queue = OperationQueue()

let subscription = queue.publisher(for: \.operationCount)
  .sink {
    print("Outstanding operations in queue: \($0)")
  }

queue.addOperation {
  print("HI")
}

class TestObject: NSObject {
  @objc dynamic var integerProperty: Int = 0
  @objc dynamic var stringProperty: String = ""
  @objc dynamic var arrayProperty: [Float] = []
}

let obj = TestObject()

let subscription1 = obj.publisher(for: \.integerProperty, options: [.prior])
  .sink {
    print("integerProperty changes to \($0)")
  }

let subscription2 = obj.publisher(for: \.stringProperty, options: [])
  .sink {
    print("stringProperty changes to \($0)")
  }

let subscription3 = obj.publisher(for: \.arrayProperty)
  .sink {
    print("arrayProperty changes to \($0)")
  }


obj.integerProperty = 100
obj.integerProperty = 200

obj.stringProperty = "Hello"
obj.arrayProperty = [1.0]
obj.stringProperty = "World"
obj.arrayProperty = [1.0, 2.0]

class MonitorObject: ObservableObject {
  @Published var someProperty = false
  @Published var someOtherProperty = ""
}

let object = MonitorObject()

let subscription4 = object.objectWillChange.sink {
  print("object will change")
}

object.someProperty = true
object.someOtherProperty = "Hello world"


//: [Next](@next)
