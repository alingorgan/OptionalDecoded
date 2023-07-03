import Foundation

public protocol OptionalDecodedWrapper {
    associatedtype WrappedType: Decodable
    var wrappedValue: WrappedType? { get }
    init(wrappedValue: WrappedType?)
}

public extension KeyedDecodingContainer {
    // This allows the decoder to understand it shouldn't fail decoding when the value isn't there
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T
        where T: Decodable, T: OptionalDecodedWrapper {
        try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
    }

    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T
        where T: Decodable, T: OptionalDecodedWrapper, T.WrappedType: Collection, T.WrappedType.Element: Decodable
    {
        guard type.WrappedType.self == Array<T.WrappedType.Element>.self else { return .init(wrappedValue: nil)}
        let result = try decode([T.WrappedType.Element].self, forKey: key)
        return T(wrappedValue: (result as? T.WrappedType))
    }

    func decode<T>(_ type: Array<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Array<T> where T: Decodable {
        var result = Array<T>()
        var container = try nestedUnkeyedContainer(forKey: key)
        while !container.isAtEnd {
            let nestedDecoder = try container.superDecoder()
            if let decodedElement = try? T(from: nestedDecoder) {
                result.append(decodedElement)
            }
        }
        return result
    }
}

