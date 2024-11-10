//
//	URL+FileTests.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2024-11-04.
//	Copyright © 2024 Steven Woolgar. All rights reserved.
//

import Foundation
@testable import music_notation_import
import System
import Testing

@Suite final class URLExtensionTests {
	@Test func fileExists() async throws {
		let filenamePath = FilePath("testfile.txt")
		guard let filePath = Bundle.main.path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension,
			inDirectory: "TestFiles"
		) else {
			Issue.record("Bundle path not found (testfile.txt)")
			throw URLExtensionTestError.generalFailure
		}
	}
}

enum URLExtensionTestError: Error {
	case generalFailure
}

/*
extension URL {
	var fileExists: Bool { FileManager.default.exists(atUrl: self) == .file }
	var isFolder: Bool { FileManager.default.exists(atUrl: self) == .folder }

	func hasExtension(_ extensionStrings: [String]) -> Bool {
		guard fileExists else { return false }

		let matchingExtensions = extensionStrings.filter { pathExtension == $0 }
		return !matchingExtensions.isEmpty
	}
}
*/
