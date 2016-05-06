@testable import Seria

enum Gender: String, SerializableType {
	case male = "male"
	case female = "female"
}

class Person: Serializable {
	var name: String!
	var age: UInt!
	var gender: Gender?

	required init() {

	}

	init(name: String, age: UInt, gender: Gender? = nil) {
		self.name = name
		self.age = age
		self.gender = gender
	}

	func map(s: Serializer) throws {
		try name <- s["name"]
		try age <- s["age"]
		try gender <- s["gender"]
	}

}