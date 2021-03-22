//
//	Transpose.swift
//	mnc-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright (c) 2020-2021, Steven Woolgar
//

import Foundation
import SWXMLHash

//<Transpose>
//	<Chromatic>0</Chromatic>
//	<Octave>0</Octave>
//</Transpose>

struct Transpose: XMLIndexerDeserializable {
	var chromatic: Bool

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Transpose(
			chromatic: Bool(node["Chromatic"].value())
		)
	}
}
