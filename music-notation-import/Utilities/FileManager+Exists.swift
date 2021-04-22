//
//	FileManager+Exists.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2020-12-02.
//	Copyright © 2020 Steven Woolgar. All rights reserved.
//

import Foundation

public enum FileExists: Equatable {
	case none
	case file
	case folder
}

public func == (lhs: FileExists, rhs: FileExists) -> Bool {
	switch (lhs, rhs) {
	case (.none, .none),
		 (.file, .file),
		 (.folder, .folder):
		return true

	default: return false
	}
}

public extension FileManager {
	func exists(atUrl url: URL) -> FileExists {
		var isDirectory: ObjCBool = false
		let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)

		switch (exists, isDirectory.boolValue) {
		case (false, _): return .none
		case (true, false): return .file
		case (true, true): return .folder
		}
	}
}
