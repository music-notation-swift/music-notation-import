//
//	URL+FileTests.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2024-11-04.
//	Copyright © 2024 Steven Woolgar. All rights reserved.
//

import Foundation
import System
import Testing

@Suite final class URLExtensionTests {
	@Test func fileExists() async throws {
		let filenamePath = FilePath("testfile.txt")
		guard let filePath = Bundle(for: Self.self).path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension
		) else {
			Issue.record("Bundle path not found (testfile.txt)")
			throw URLExtensionTestError.generalFailure
		}

		let fileURL = URL(fileURLWithPath: filePath)
		let urlExists = fileURL.fileExists
		#expect(urlExists == true)
	}

	@Test func folderExists() async throws {
		let filenamePath = FilePath("testfile.txt")
		guard let filePath = Bundle(for: Self.self).path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension
		) else {
			Issue.record("Bundle path not found (testfile.txt)")
			throw URLExtensionTestError.generalFailure
		}

		let fileURL = URL(fileURLWithPath: filePath)
		let urlExists = fileURL.isFolder
		#expect(urlExists == false)
	}

	@Test func hasExtension() async throws {
		let filenamePath = FilePath("testfile.txt")
		guard let filePath = Bundle(for: Self.self).path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension
		) else {
			Issue.record("Bundle path not found (testfile.txt)")
			throw URLExtensionTestError.generalFailure
		}

		let fileURL = URL(fileURLWithPath: filePath)
		#expect(fileURL.hasExtension(["txt"]) == true)
	}
}

enum URLExtensionTestError: Error {
	case generalFailure
}
