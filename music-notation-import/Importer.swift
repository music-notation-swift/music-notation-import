//
//	Importer.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-05-27.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import Foundation

public struct ImportError: Error, CustomStringConvertible {
	public internal(set) var file: URL
	public internal(set) var message: String

	/// Creates a new validation error with the given message.
	public init(file: URL, _ message: String) {
		self.file = file
		self.message = message
	}

	public var description: String { message }
}
