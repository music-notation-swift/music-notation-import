//
//	GuitarPro7Importer.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2020-12-02.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import MusicNotation
import MusicNotationImportGuitarPro
import SWXMLHash
import ZIPFoundation

struct GuitarPro7Importer {
	let file: URL
	let options: ImportOptions

	func consume() throws -> MusicNotation.Score {
		if options.verbose { print("--- Starting parsing of: \(file) ---") }
		defer { if options.verbose { print("--- Ending parsing of: \(file) ---") } }

		var xmlString: String

		switch file.pathExtension {
		case "gpif":
			guard let string = try? String(contentsOf: file) else { throw ImportError(file: file, "Could not open gpif file") }
			xmlString = string

		case "gp":
			guard let archive = Archive(url: file, accessMode: .read) else { throw ImportError(file: file, "Could not open gp archive") }
			guard let scoreEntry = archive["Content/score.gpif"] else { throw ImportError(file: file, "Could not open score.gpif inside gp archive") }

			var xmlData = Data()

			_ = try archive.extract(scoreEntry, consumer: { data in
				xmlData.append(data)
			})

			guard let string = String(data: xmlData, encoding: .utf8) else { throw ImportError(file: file, "Could not convert data from archive to string") }
			xmlString = string

		default:
			xmlString = ""
		}

		let interchangeFormat = try parseXML(xmlString)
		return try createNotation(with: interchangeFormat)
	}

	func parseXML(_ xmlString: String) throws -> MusicNotationImportGuitarPro.GuitarProInterchangeFormat {
		let xml = SWXMLHash.config { config in
			config.shouldProcessLazily = options.lazy
			config.detectParsingErrors = true
		}.parse(xmlString)

		return try xml["GPIF"].value()
	}

	func createNotation(with interchangeFormat: MusicNotationImportGuitarPro.GuitarProInterchangeFormat) throws -> MusicNotation.Score {
		let parts = interchangeFormat.tracks.map { track in
			MusicNotation.Part(with: track)
		}

		return MusicNotation.Score(parts: parts)
	}
}
