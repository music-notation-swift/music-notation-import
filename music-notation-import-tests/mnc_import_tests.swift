//
//	mnc_import_tests.swift
//	music-notation-import-tests
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import SWXMLHash
import XCTest

struct SampleUserInfo {
	enum ApiVersion {
		case version1
		case version2
	}

	var apiVersion = ApiVersion.version2

	func suffix() -> String {
		if apiVersion == ApiVersion.version1 {
			return " (v1)"
		} else {
			return ""
		}
	}

	static let key = CodingUserInfoKey(rawValue: "test")!

	init(apiVersion: ApiVersion) {
		self.apiVersion = apiVersion
	}
}

struct BasicItem: XMLObjectDeserialization {
	let name: String
	let price: Double
	let id: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		var name: String = try node["name"].value()

		if let opts = node.userInfo[SampleUserInfo.key] as? SampleUserInfo {
			name += opts.suffix()
		}

		return try BasicItem(
			name: name,
			price: node["price"].value(),
			id: node.value(ofAttribute: "id")
		)
	}
}

extension BasicItem: Equatable {
	static func == (lhs: BasicItem, rhs: BasicItem) -> Bool {
		lhs.name == rhs.name && lhs.price == rhs.price
	}
}

struct AttributeItem: XMLElementDeserializable {
	let name: String
	let price: Double

	static func deserialize(_ element: SWXMLHash.XMLElement) throws -> AttributeItem {
		try AttributeItem(
			name: element.value(ofAttribute: "name"),
			price: element.value(ofAttribute: "price")
		)
	}
}

extension AttributeItem: Equatable {
	static func == (lhs: AttributeItem, rhs: AttributeItem) -> Bool {
		lhs.name == rhs.name && lhs.price == rhs.price
	}
}

struct AttributeItemStringRawRepresentable: XMLElementDeserializable {
	private enum Keys: String {
		case name
		case price
	}

	let name: String
	let price: Double

	static func deserialize(_ element: SWXMLHash.XMLElement) throws -> AttributeItemStringRawRepresentable {
		try AttributeItemStringRawRepresentable(
			name: element.value(ofAttribute: Keys.name),
			price: element.value(ofAttribute: Keys.price)
		)
	}
}

extension AttributeItemStringRawRepresentable: Equatable {
	static func == (lhs: AttributeItemStringRawRepresentable, rhs: AttributeItemStringRawRepresentable) -> Bool {
		lhs.name == rhs.name && lhs.price == rhs.price
	}
}

class TypeConversionComplexTypesTests: XCTestCase {
	var parser: XMLIndexer?
	let xmlWithComplexType = """
		<root>
		  <complexItem>
			<name>the name of complex item</name>
			<price>1024</price>
			<basicItems>
			  <basicItem id="1234a">
				<name>item 1</name>
				<price>1</price>
			  </basicItem>
			  <basicItem id="1234a">
				<name>item 2</name>
				<price>2</price>
			  </basicItem>
			  <basicItem id="1234a">
				<name>item 3</name>
				<price>3</price>
			  </basicItem>
			</basicItems>
			<attributeItems>
			  <attributeItem name=\"attr1\" price=\"1.1\"/>
			  <attributeItem name=\"attr2\" price=\"2.2\"/>
			  <attributeItem name=\"attr3\" price=\"3.3\"/>
			</attributeItems>
		  </complexItem>
		  <empty></empty>
		</root>
	"""

	let correctComplexItem = ComplexItem(
		name: "the name of complex item",
		priceOptional: 1_024,
		basics: [
			BasicItem(name: "item 1", price: 1, id: "1234a"),
			BasicItem(name: "item 2", price: 2, id: "1234b"),
			BasicItem(name: "item 3", price: 3, id: "1234c")
		],
		attrs: [
			AttributeItem(name: "attr1", price: 1.1),
			AttributeItem(name: "attr2", price: 2.2),
			AttributeItem(name: "attr3", price: 3.3)
		]
	)

	override func setUpWithError() throws {
		parser = XMLHash.parse(xmlWithComplexType)
	}

	func testShouldConvertComplexitemToNonOptional() throws {
		do {
			let value: ComplexItem = try parser!["root"]["complexItem"].value()
			XCTAssertEqual(value, correctComplexItem)
		} catch {
			XCTFail("\(error)")
		}
	}

	func testShouldThrowWhenConvertingEmptyToNonOptional() throws {
		XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldThrowWhenConvertingMissingToNonOptional() throws {
		XCTAssertThrowsError(try (parser!["root"]["missing"].value() as ComplexItem)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldConvertComplexitemToOptional() throws {
		do {
			let value: ComplexItem? = try parser!["root"]["complexItem"].value()
			XCTAssertEqual(value, correctComplexItem)
		} catch {
			XCTFail("\(error)")
		}
	}

	func testShouldConvertEmptyToOptional() throws {
		XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem?)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldConvertMissingToOptional() throws {
		do {
			let value: ComplexItem? = try parser!["root"]["missing"].value()
			XCTAssertNil(value)
		} catch {
			XCTFail("\(error)")
		}
	}
}

struct ComplexItem: XMLObjectDeserialization {
	let name: String
	let priceOptional: Double?
	let basics: [BasicItem]
	let attrs: [AttributeItem]

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try ComplexItem(
			name: node["name"].value(),
			priceOptional: node["price"].value(),
			basics: node["basicItems"]["basicItem"].value(),
			attrs: node["attributeItems"]["attributeItem"].value()
		)
	}
}

extension ComplexItem: Equatable {
	static func == (lhs: ComplexItem, rhs: ComplexItem) -> Bool {
		lhs.name == rhs.name && lhs.priceOptional == rhs.priceOptional && lhs.basics == rhs.basics && lhs.attrs == rhs.attrs
	}
}

extension TypeConversionComplexTypesTests {
	static var allTests: [(String, (TypeConversionComplexTypesTests) -> () throws -> Void)] {
		[
			("testShouldConvertComplexitemToNonOptional", testShouldConvertComplexitemToNonOptional),
			("testShouldThrowWhenConvertingEmptyToNonOptional", testShouldThrowWhenConvertingEmptyToNonOptional),
			("testShouldThrowWhenConvertingMissingToNonOptional", testShouldThrowWhenConvertingMissingToNonOptional),
			("testShouldConvertComplexitemToOptional", testShouldConvertComplexitemToOptional),
			("testShouldConvertEmptyToOptional", testShouldConvertEmptyToOptional),
			("testShouldConvertMissingToOptional", testShouldConvertMissingToOptional)
		]
	}
}
