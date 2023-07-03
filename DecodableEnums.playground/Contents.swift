import Foundation

public enum Signal: String, Decodable, CustomStringConvertible {
    case analog
    case digital
    
    public var description: String {
        rawValue
    }
}

struct SingleValueReceiver: Decodable {
    @OptionalDecoded var signal: Signal?
}

struct MultiValueReceiver: Decodable {
    @OptionalDecoded var signals: [Signal]?
}

run(scenario: "Data contains known value") {
    let data = """
    { "signal": "digital" }
    """.data(using: .utf8)!
    
    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: digital
}

run(scenario: "Data doesn't contain any value") {
    let data = "{}".data(using: .utf8)!
    
    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: nil
}

run(scenario: "Data contains null value") {
    let data = """
    { "signal": null }
    """.data(using: .utf8)!

    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: nil
}

run(scenario: "Data contains an array of optional decodable values") {
    let data = """
    { "signals": ["digital", "analog"] }
    """.data(using: .utf8)!
    
    let parentReceiver = try! JSONDecoder().decode(MultiValueReceiver.self, from: data)
    print(String(describing: parentReceiver.signals) as Any)
    
    // Prints value: Optional(["digital", "analog"])
}

run(scenario: "Data contains an array of optional decodable values, where some are unknown") {
    let data = """
    { "signals": ["digital", "analog1"] }
    """.data(using: .utf8)!
    
    let parentReceiver = try! JSONDecoder().decode(MultiValueReceiver.self, from: data)
    print(String(describing: parentReceiver.signals) as Any)
    
    // Prints value: Optional(["digital"])
}
