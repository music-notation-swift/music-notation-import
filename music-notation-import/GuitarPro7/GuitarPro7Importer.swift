//
//	GuitarPro7Importer.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2020-12-02.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash
import ZIPFoundation
import MusicNotation

public struct GuitarPro7ImportError: Error, CustomStringConvertible {
	public internal(set) var file: URL
	public internal(set) var message: String

	/// Creates a new validation error with the given message.
	public init(file: URL, _ message: String) {
		self.file = file
		self.message = message
	}

	public var description: String { message }
}

struct GuitarPro7Importer {
	let file: URL
	let options: ImportOptions

	func consume() throws -> MusicNotation.Score {
		if options.verbose { print("--- Starting parsing of: \(file) ---") }
		defer { if options.verbose { print("--- Ending parsing of: \(file) ---") } }

		var xmlString: String

		switch file.pathExtension {
		case "gpif":
			guard let string = try? String(contentsOf: file) else { throw GuitarPro7ImportError(file: file, "Could not open gpif file") }
			xmlString = string

		case "gp":
			guard let archive = Archive(url: file, accessMode: .read) else { throw GuitarPro7ImportError(file: file, "Could not open gp archive") }
			guard let scoreEntry = archive["Content/score.gpif"] else { throw GuitarPro7ImportError(file: file, "Could not open score.gpif inside gp archive") }

			var xmlData = Data()

			_ = try archive.extract(scoreEntry, consumer: { (data) in
				xmlData.append(data)
			})

			guard let string = String(data: xmlData, encoding: .utf8) else { throw GuitarPro7ImportError(file: file, "Could not convert data from archive to string") }
			xmlString = string

		default:
			xmlString = ""
		}

		let interchangeFormat = try parseXML(xmlString)
		try createNotation(with: interchangeFormat)

		let staff = MusicNotation.Staff(clef: Clef.treble, instrument: .guitar6)
		return MusicNotation.Score(staves: [staff])
	}

	func parseXML(_ xmlString: String) throws -> GuitarProInterchangeFormat {
		let xml = SWXMLHash.config { config in
			config.shouldProcessLazily = options.lazy
			config.detectParsingErrors = true
		}.parse(xmlString)

		let interchangeFormat: GuitarProInterchangeFormat = try xml["GPIF"].value()
		print("noteCount = \(noteCount), tieCount = \(tieCount), accentCount = \(accentCount), antiAccentCount = \(antiAccentCount), vibratoCount = \(vibratoCount), letRingCount = \(letRingCount)")

		return interchangeFormat
	}

	func createNotation(with interchangeFormat: GuitarProInterchangeFormat) throws {
	}
}
