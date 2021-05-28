//
//	LilyPondImporter.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-05-27.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import Foundation
import MusicNotation
import MusicNotationImportLilyPond

struct LilyPondImporter {
	let file: URL
	let options: ImportOptions

	func consume() throws -> MusicNotation.Score {
		if options.verbose { print("--- Starting parsing of: \(file) ---") }
		defer { if options.verbose { print("--- Ending parsing of: \(file) ---") } }

		var lilyPondString: String

		switch file.pathExtension {
		case "ly":
			guard let string = try? String(contentsOf: file) else { throw ImportError(file: file, "Could not open ly file") }
			lilyPondString = string

		default:
			lilyPondString = ""
		}

		let interchangeFormat = try parse(lilyPondString)
		return try createNotation(with: interchangeFormat)
	}

	func parse(_ string: String) throws -> MusicNotationImportLilyPond.LilyPondInterchangeFormat {
		MusicNotationImportLilyPond.LilyPondInterchangeFormat()
	}

	func createNotation(with interchangeFormat: MusicNotationImportLilyPond.LilyPondInterchangeFormat) throws -> MusicNotation.Score {
		MusicNotation.Score(parts: [])
	}
}
