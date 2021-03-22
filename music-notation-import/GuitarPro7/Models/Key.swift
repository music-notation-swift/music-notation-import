//
//	Key.swift
//	mnc-import
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright (c) 2020-2021, Steven Woolgar
//

import Foundation
import SWXMLHash

//<Key>
//  <AccidentalCount>4</AccidentalCount>
//  <Mode>Major</Mode>
//  <TransposeAs>Sharps</TransposeAs>
//</Key>

struct Key: XMLIndexerDeserializable {
	var accidentalCount: Int
	var mode: String
	var transposeAs: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Key(
			accidentalCount: node["AccidentalCount"].value(),
			mode: node["Mode"].value(),
			transposeAs: node["TransposeAs"].value()
		)
	}
}
