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
}
