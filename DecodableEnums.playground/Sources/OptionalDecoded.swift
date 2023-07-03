import Foundation

@propertyWrapper
public struct OptionalDecoded<Wrapped: Decodable>: OptionalDecodedWrapper {
    public var wrappedValue: Wrapped?
    
    public init(wrappedValue: Wrapped?) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalDecoded: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            let decodedValue = try decoder
                .singleValueContainer()
                .decode(Wrapped.self)
            wrappedValue = .some(decodedValue)
        } catch is DecodingError {
            wrappedValue = nil
        }
    }
}
