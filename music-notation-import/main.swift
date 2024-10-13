//
//	main.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-01.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import ArgumentParser
import Foundation
import MusicNotationImportGuitarPro
import MusicNotationImportMuseScore

let argumentHelp: ArgumentHelp = """
A filename of a file to import.

Currently supported music notation file types include:
	• Guitar Pro 8 - These are zipped XML files
"""

// swiftlint:disable type_name
struct mncimport: AsyncParsableCommand {
	@Argument(help: argumentHelp, transform: { URL(fileURLWithPath: NSString(string: $0).expandingTildeInPath) }) var files: [URL]
	@Flag(name: [.customLong("verbose"), .customShort("v")], help: "Shows verbose output.") var verbose = false
	@Flag(name: [.customLong("lazy"), .customShort("l")], help: "Process XML lazily.") var lazy = false

	mutating func validate() throws {
		for file in files {
			if !file.isFileURL {
				throw ValidationError("`\(file.lastPathComponent)` must be a valid reference to a local file.")
			}

			if file.isFolder {
				throw ValidationError("`\(file.lastPathComponent)` is a folder.")
			}

			if !file.fileExists {
				throw ValidationError("`\(file.lastPathComponent)` not found.")
			}

			if !file.hasExtension(["gpif", "gp", "lilypond", "mscz"]) {
				throw ValidationError("`\(file.lastPathComponent)` doesn't have supported import file extension.")
			}
		}
	}

	func run() throws {
		let importOptions = ImportOptions()
		for file in files {
			let fileExtension = file.pathExtension
			switch fileExtension {
			case "gp", "gpif":
                let importer = GuitarPro8Importer(file: file, verbose: importOptions.verbose, lazy: importOptions.lazy)
				let score = try importer.consume()
				print("Resulting score is: \(score)")
			case "mscz", "mscx":
				let importer = MuseScoreImporter(file: file, verbose: importOptions.verbose, lazy: importOptions.lazy)
				let score = try importer.consume()
				print("Resulting score is: \(score)")
			default:
				print("Unsupported file type \(fileExtension)")
			}
		}
	}
}

mncimport.main()
// swiftlint:enable type_name
