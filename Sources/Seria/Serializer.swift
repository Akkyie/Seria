enum SerializeError: ErrorProtocol {
	case serializedValueNotFound(properyName: String)
	case deserializeFailed(properyName: String)
}

infix operator <- { }

public func <-<Type: SerializableType>(propery: inout Type, info: PropertyInfo) throws {
	switch info.serializer.direction {
	case .serialize:
		info.serializer.dictionary[info.name] = propery.serialize()
	case .deserialize:
		guard let serialized = info.serializer.dictionary[info.name] else {
			throw SerializeError.serializedValueNotFound(properyName: info.name)
		}
		guard let value = Type(deserialize: serialized) else {
			throw SerializeError.deserializeFailed(properyName: info.name)
		}
		propery = value
	}
}

public func <-<Type: SerializableType>(propery: inout Type!, info: PropertyInfo) throws {
	switch info.serializer.direction {
	case .serialize:
		info.serializer.dictionary[info.name] = propery?.serialize()
	case .deserialize:
		guard let serialized = info.serializer.dictionary[info.name] else {
			throw SerializeError.serializedValueNotFound(properyName: info.name)
		}
		guard let value = Type(deserialize: serialized) else {
			throw SerializeError.deserializeFailed(properyName: info.name)
		}
		propery = value
	}
}

public func <-<Type: SerializableType>(propery: inout Type?, info: PropertyInfo) throws {
	switch info.serializer.direction {
	case .serialize:
		info.serializer.dictionary[info.name] = propery?.serialize()
	case .deserialize:
		guard let serialized = info.serializer.dictionary[info.name] else {
			propery = nil
			return
		}
		guard let value = Type(deserialize: serialized) else {
			propery = nil
			return
		}
		propery = value
	}
}

public protocol SerializableType {
	init?(deserialize string: String)
	func serialize() -> String
}

public class Serializer {
	enum Direction {
		case serialize
		case deserialize
	}

	private var dictionary: [String: String]
	private var direction: Direction

	subscript(name: String) -> PropertyInfo {
		get {
			return PropertyInfo(serializer: self, name: name)
		}
	}

	init(dictionary: [String: String], direction: Direction) {
		self.dictionary = dictionary
		self.direction = direction
	}
}

public class PropertyInfo {
	public let serializer: Serializer
	public let name: String

	init(serializer: Serializer, name: String) {
		self.serializer = serializer
		self.name = name
	}
}

public protocol Serializable: class {
	init()
	func map(s: Serializer) throws
}

extension Serializable {
	public func serialize() throws -> [String: String] {
		let serializer = Serializer(dictionary: [:], direction: .serialize)
		try map(s: serializer)
		return serializer.dictionary
	}

	init?(dictionary: [String: String]) throws {
		let serializer = Serializer(dictionary: dictionary, direction: .deserialize)
		self.init()
		try self.map(s: serializer)
	}
}