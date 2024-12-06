//
//	mainTests.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2024-12-02.
//	Copyright © 2024 Steven Woolgar. All rights reserved.
//

@testable import ArgumentParser
import Foundation
import System
import Testing

@Suite final class MainTests {
	@Test func fileExists() async throws {
		#expect(throws: CommandError.self) {
			_ = try mncimport.parseAsRoot(["test.gp"])
		}
	}

	@Test func unsupportedExtension() async throws {
		let filenamePath = FilePath("testfile.txt")
		guard let filePath = Bundle(for: type(of: self)).path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension
		) else {
			Issue.record("Bundle path not found")
			return
		}

		#expect(throws: CommandError.self) {
			_ = try mncimport.parseAsRoot([filePath])
		}
	}

	@Test func supplyingFolderInstead() async throws {
		let filePath = Bundle(for: type(of: self)).bundlePath
		#expect(throws: CommandError.self) {
			_ = try mncimport.parseAsRoot([filePath])
		}
	}
}
