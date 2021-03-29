//
//	TimeSignatureParserTests.swift
//	music-notation-import-tests
//
//	Created by Steven Woolgar on 2021-02-24.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import XCTest
@testable import music_notation_import

/// There are issues with the domain knowledge acquired and that needed to properly implement
/// a good deal of Time Signatures parsing.
///
/// I have not been able to find enough data to correctly parse and algorithmically determine
/// what is a simple, compound, complex time signature as well as the state of `oddness` of a time signature.
///
/// For now this will have to do and I will ammend the code and tests when I have better domain expertise.
class TimeSignatureParserTests: XCTestCase {
	func testSimple() {
		do {
			let signature = try TimeSignature.type(from: "4/4")
			XCTAssertEqual(signature, .simple(4, 4))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "2/4")
			XCTAssertEqual(signature, .simple(2, 4))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "3/4")
			XCTAssertEqual(signature, .simple(3, 4))
		} catch {
			XCTFail("\(error)")
		}
	}

	func testCompound() {
		do {
			let signature = try TimeSignature.type(from: "3/8")
			XCTAssertEqual(signature, .compound(3, 8))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "6/8")
			XCTAssertEqual(signature, .compound(6, 8))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "9/8")
			XCTAssertEqual(signature, .compound(9, 8))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "12/8")
			XCTAssertEqual(signature, .compound(12, 8))
		} catch {
			XCTFail("\(error)")
		}
	}

	func testOdd() {
		do {
			let signature = try TimeSignature.type(from: "5/4")
			XCTAssertTrue(signature.oddMeter())
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "7/8")
			XCTAssertTrue(signature.oddMeter())
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "11/16")
			XCTAssertTrue(signature.oddMeter())
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "7/16")
			XCTAssertTrue(signature.oddMeter())
		} catch {
			XCTFail("\(error)")
		}
	}

	func testComplex() {
		do {
			let signature = try TimeSignature.type(from: "6/3")
			XCTAssertEqual(signature, .complex(6, 3))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "5/24")
			XCTAssertEqual(signature, .complex(5, 24))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let signature = try TimeSignature.type(from: "3/10")
			XCTAssertEqual(signature, .complex(3, 10))
		} catch {
			XCTFail("\(error)")
		}
	}

	func testFractional() {
		do {
			let fractionalSignature = try TimeSignature.type(from: "2.5/4")
			XCTAssertEqual(fractionalSignature, .fractional(2.5, 4))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let fractionalSignature = try TimeSignature.type(from: "5.1/24")
			XCTAssertEqual(fractionalSignature, .fractional(5.1, 24))
		} catch {
			XCTFail("\(error)")
		}

		do {
			let fractionalSignature = try TimeSignature.type(from: "3.666/10")
			XCTAssertEqual(fractionalSignature, .fractional(3.666, 10))
		} catch {
			XCTFail("\(error)")
		}
	}

	func testAdditive() {
		do {
			let additiveSignature = try TimeSignature.type(from: "3+2/8+3")
			XCTAssertEqual(additiveSignature, .additive([3, 2, 3], 8))
		} catch {
			XCTFail("\(error)")
		}

		do {
			_ = try TimeSignature.type(from: "")
			XCTFail("We should have thrown an exception and not arrive here")
		} catch {
			// This is where we should end up
		}
	}
}
