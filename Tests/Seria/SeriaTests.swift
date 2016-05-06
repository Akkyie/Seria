import XCTest
@testable import Seria

class SeriaTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
	}

	func testSerialize() {
		let taro = Person(name: "Taro Tanaka", age: 10, gender: .male)
		do {
			let dictionary = try taro.serialize()
			let expected = [
			               	"name": "Taro Tanaka",
			               	"age": "10",
			               	"gender": "male"
			]
			XCTAssertEqual(dictionary, expected)
		} catch let error {
			XCTFail("\(error)")
		}
	}

	func testDeserialize() {
		let dictionary = [
		                 	"name": "Hanako Yamada",
		                 	"age": "20",
		                 	"gender": "female"
		]
		do {
			let hanako = try Person(dictionary: dictionary)
			XCTAssertNotNil(hanako)
			XCTAssertEqual(hanako!.name, "Hanako Yamada")
			XCTAssertEqual(hanako!.age, 20)
			XCTAssertEqual(hanako!.gender, .female)
		} catch let error {
			XCTFail("\(error)")
		}
	}

	func testDeserializeFail() {
		let dictionary = [
		                 	"name": "John Smith"
		]
		do {
			let _ = try Person(dictionary: dictionary)
		} catch SerializeError.serializedValueNotFound(properyName: let name) {
			XCTAssertEqual(name, "age")
		} catch let error {
			XCTFail("\(error)")
		}
	}

}
