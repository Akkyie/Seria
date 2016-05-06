extension String: SerializableType {
	public init?(deserialize string: String) {
		self = string
	}

	public func serialize() -> String {
		return self
	}
}

public protocol IntegerSerializableType: CustomStringConvertible, SerializableType {
	init?(_ text: String, radix: Int)
}

extension IntegerSerializableType {
	public init?(deserialize string: String) {
		self.init(string, radix: 10)
	}

	public func serialize() -> String {
		return self.description
	}
}

extension Int: IntegerSerializableType {}
extension Int8: IntegerSerializableType {}
extension Int16: IntegerSerializableType {}
extension Int32: IntegerSerializableType {}
extension Int64: IntegerSerializableType {}

extension UInt: IntegerSerializableType {}
extension UInt8: IntegerSerializableType {}
extension UInt16: IntegerSerializableType {}
extension UInt32: IntegerSerializableType {}
extension UInt64: IntegerSerializableType {}

public protocol FloatingPointSerializableType: CustomStringConvertible, SerializableType {
	init?(_ text: String)
}

extension FloatingPointSerializableType {
	public init?(deserialize string: String) {
		self.init(string)
	}

	public func serialize() -> String {
		return self.description
	}
}

extension Float32: FloatingPointSerializableType {}
extension Float64: FloatingPointSerializableType {}
extension Float80: FloatingPointSerializableType {}

extension RawRepresentable where RawValue: SerializableType {
	public init?(deserialize string: String) {
		guard let rawValue = RawValue(deserialize: string) else {
			return nil
		}
		self.init(rawValue: rawValue)
	}

	public func serialize() -> String {
		return self.rawValue.serialize()
	}
}
