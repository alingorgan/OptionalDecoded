# Optional Decoding

## A solution for optionally decoding enums which can contain incompatible values

## Example value and containers

```swift
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
```

## Scenarios

### Scenario 1: Data contains known value
```swift
    let data = """
    { "signal": "digital" }
    """.data(using: .utf8)!
    
    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: digital
```

### Scenario 2: Data doesn't contain any value
```swift
    let data = "{}".data(using: .utf8)!
    
    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: nil
```

### Scenario 3: Data contains null value
```swift
    let data = """
    { "signal": null }
    """.data(using: .utf8)!

    let receiver = try! JSONDecoder().decode(SingleValueReceiver.self, from: data)
    print(String(describing: receiver.signal as Any))
    
    // Prints value: nil
```

### Scenario 4: Data contains an array of optional decodable values
```swift
    let data = """
    { "signals": ["digital", "analog"] }
    """.data(using: .utf8)!
    
    let parentReceiver = try! JSONDecoder().decode(MultiValueReceiver.self, from: data)
    print(String(describing: parentReceiver.signals) as Any)
    
    // Prints value: Optional(["digital", "analog"])
```

### Scenario 5: Data contains an array of optional decodable values, where some are unknown
```swift
    let data = """
    { "signals": ["digital", "analog1"] }
    """.data(using: .utf8)!
    
    let parentReceiver = try! JSONDecoder().decode(MultiValueReceiver.self, from: data)
    print(String(describing: parentReceiver.signals) as Any)
    
    // Prints value: Optional(["digital"])
```
