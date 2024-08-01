import Foundation

class MyType: Codable {}

let url = URL(string: "https://mysite.com/myData.json")!

let subscription = URLSession.shared
  .dataTaskPublisher(for: url)
//  .tryMap { data, _ in
//    try JSONDecoder().decode(MyType.self, from: data)
//  }
  .map(\.data)
  .decode(type: MyType.self, decoder: JSONDecoder())
  .sink { completion in
    if case .failure(let err) = completion {
      print("Retrieving data failed with error \(err)")
    }
  } receiveValue: { object in
    print("Retrieved object \(object)")
  }

