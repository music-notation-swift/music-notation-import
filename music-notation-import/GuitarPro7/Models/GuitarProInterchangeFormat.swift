//
//	GuitarProInterchangeFormat.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

struct Revision: XMLIndexerDeserializable {
	var value: Int

	var required: Int
	var recommended: Int

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Revision(
			value: node.value(),
			required: node.value(ofAttribute: "required"),
			recommended: node.value(ofAttribute: "recommended")
		)
	}
}

struct MasterTrack: XMLIndexerDeserializable {
	var tracks: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try MasterTrack(
			tracks: node["Tracks"].value()
		)
	}
}

struct Bar: XMLIndexerDeserializable {
	var clef: String
	var voices: [Int]

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let voices: String = try node["Voices"].value()
		let voicesArray = voices.split(separator: " ")

		return try Bar(
			clef: node["Clef"].value(),
			voices: voicesArray.compactMap { Int($0) }
		)
	}
}

struct GuitarProInterchangeFormat: XMLIndexerDeserializable {
	var version: Int
	var revision: Revision
	var encoding: String
	var score: Score
	var masterTrack: MasterTrack
	var tracks: [Track]
	var masterBars: [MasterBar]
	var bars: [Bar]
	var voices: [Voice]
	var beats: [Beat]
	var notes: [Note]
	var rhythms: [Rhythm]

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try GuitarProInterchangeFormat(
			version: node["GPVersion"].value(),
			revision: node["GPRevision"].value(),
			encoding: node["Encoding"].value(),
			score: node["Score"].value(),
			masterTrack: node["MasterTrack"].value(),
			tracks: node["Tracks"]["Track"].value(),
			masterBars: node["MasterBars"]["MasterBar"].value(),
			bars: node["Bars"]["Bar"].value(),
			voices: node["Voices"]["Voice"].value(),
			beats: node["Beats"]["Beat"].value(),
			notes: node["Notes"]["Note"].value(),
			rhythms: node["Rhythms"]["Rhythm"].value()
		)
	}
}
