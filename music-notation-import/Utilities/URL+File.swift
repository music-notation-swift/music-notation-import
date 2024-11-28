//
//	URL+File.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2020-12-02.
//	Copyright © 2020 Steven Woolgar. All rights reserved.
//

import Foundation

public extension URL {
	var fileExists: Bool { FileManager.default.exists(atUrl: self) == .file }
	var isFolder: Bool { FileManager.default.exists(atUrl: self) == .folder }

	func hasExtension(_ extensionStrings: [String]) -> Bool {
		guard fileExists else { return false }

		let matchingExtensions = extensionStrings.filter { pathExtension == $0 }
		return !matchingExtensions.isEmpty
	}
}
