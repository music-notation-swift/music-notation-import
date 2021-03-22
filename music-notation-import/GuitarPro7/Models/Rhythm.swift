//
//	Rhythm.swift
//	mnc-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright (c) 2020-2021, Steven Woolgar
//

import Foundation
import SWXMLHash

struct Rhythm: XMLIndexerDeserializable {
	var id: Int

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Rhythm(
			id: node.value(ofAttribute: "id")
		)
	}
}
