//
//	MasterBar.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

/// NB: As per the XML file, order of masterbars are important.

struct MasterBar: XMLIndexerDeserializable {
	var key: Key
	var timeSignature: TimeSignature

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try MasterBar(
			key: node["Key"].value(),
			timeSignature: node["Time"].value()
		)
	}
}
