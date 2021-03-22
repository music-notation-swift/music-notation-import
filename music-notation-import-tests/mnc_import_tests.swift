//
//  mnc_import_tests.swift
//  mnc-import-tests
//
//  Created by Steven Woolgar on 2021/02/10.
//

import SWXMLHash
import XCTest

struct SampleUserInfo {
	enum ApiVersion {
		case v1
		case v2
	}

	var apiVersion = ApiVersion.v2

	func suffix() -> String {
		if apiVersion == ApiVersion.v1 {
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

struct BasicItem: XMLIndexerDeserializable {
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
	static func == (a: BasicItem, b: BasicItem) -> Bool {
		return a.name == b.name && a.price == b.price
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
	static func == (a: AttributeItem, b: AttributeItem) -> Bool {
		return a.name == b.name && a.price == b.price
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
	static func == (a: AttributeItemStringRawRepresentable, b: AttributeItemStringRawRepresentable) -> Bool {
		return a.name == b.name && a.price == b.price
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

	override func setUp() {
		super.setUp()
		parser = SWXMLHash.parse(xmlWithComplexType)
	}

	func testShouldConvertComplexitemToNonOptional() {
		do {
			let value: ComplexItem = try parser!["root"]["complexItem"].value()
			XCTAssertEqual(value, correctComplexItem)
		} catch {
			XCTFail("\(error)")
		}
	}

	func testShouldThrowWhenConvertingEmptyToNonOptional() {
		XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldThrowWhenConvertingMissingToNonOptional() {
		XCTAssertThrowsError(try (parser!["root"]["missing"].value() as ComplexItem)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldConvertComplexitemToOptional() {
		do {
			let value: ComplexItem? = try parser!["root"]["complexItem"].value()
			XCTAssertEqual(value, correctComplexItem)
		} catch {
			XCTFail("\(error)")
		}
	}

	func testShouldConvertEmptyToOptional() {
		XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem?)) { error in
			guard error is XMLDeserializationError else {
				XCTFail("Wrong type of error")
				return
			}
		}
	}

	func testShouldConvertMissingToOptional() {
		do {
			let value: ComplexItem? = try parser!["root"]["missing"].value()
			XCTAssertNil(value)
		} catch {
			XCTFail("\(error)")
		}
	}
}

struct ComplexItem: XMLIndexerDeserializable {
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
	static func == (a: ComplexItem, b: ComplexItem) -> Bool {
		return a.name == b.name && a.priceOptional == b.priceOptional && a.basics == b.basics && a.attrs == b.attrs
	}
}

extension TypeConversionComplexTypesTests {
	static var allTests: [(String, (TypeConversionComplexTypesTests) -> () throws -> Void)] {
		return [
			("testShouldConvertComplexitemToNonOptional", testShouldConvertComplexitemToNonOptional),
			("testShouldThrowWhenConvertingEmptyToNonOptional", testShouldThrowWhenConvertingEmptyToNonOptional),
			("testShouldThrowWhenConvertingMissingToNonOptional", testShouldThrowWhenConvertingMissingToNonOptional),
			("testShouldConvertComplexitemToOptional", testShouldConvertComplexitemToOptional),
			("testShouldConvertEmptyToOptional", testShouldConvertEmptyToOptional),
			("testShouldConvertMissingToOptional", testShouldConvertMissingToOptional)
		]
	}
}
