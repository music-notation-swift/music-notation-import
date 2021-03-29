//
//	Track.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

struct Track: XMLIndexerDeserializable {
	var id: Int

	var name: String
	var shortName: String
	var color: String
	var systemsDefautLayout: Int

	var systemsLayout: String
	var palmMute: Bool
	var playingStyle: String

	var iconId: Int
	var forcedSound: Int
	var playbackState: String

	var audioEngineState: String
	var staves: [Staff]
	var automations: [Automation]

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Track(
			id: node.value(ofAttribute: "id"),
			name: node["Name"].value(),
			shortName: node["ShortName"].value(),
			color: node["Color"].value(),
			systemsDefautLayout: node["SystemsDefautLayout"].value(),
			systemsLayout: node["SystemsLayout"].value(),
			palmMute: node["PalmMute"].value(),
			playingStyle: node["PlayingStyle"].value(),
			iconId: node["IconId"].value(),
			forcedSound: node["ForcedSound"].value(),
			playbackState: node["PlaybackState"].value(),
			audioEngineState: node["AudioEngineState"].value(),
			staves: node["Staves"]["Staff"].value(),
			automations: node["Automations"]["Automation"].value()
		)
	}
}
