//
//	URL+File.swift
//	mnc-import
//
//	Created by Steven Woolgar on 2020-12-02.
//	Copyright (c) 2020, Steven Woolgar
//

import Foundation

extension URL {
	var fileExists: Bool {
		get { FileManager.default.exists(atUrl: self) == .file }
	}

	var isFolder: Bool {
		get { FileManager.default.exists(atUrl: self) == .folder }
	}

	func hasExtension(_ extensionStrings: [String]) -> Bool {
		guard self.fileExists else { return false }

		let matchingExtensions = extensionStrings.filter { pathExtension == $0 }
		return matchingExtensions.count > 0
	}
}
