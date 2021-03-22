//
//	Lyrics.swift
//	mnc-import
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright (c) 2020-2021, Steven Woolgar
//

import Foundation
import SWXMLHash

//<Lyrics dispatched="true">
//	<Line>
//	  <Text>
//<![CDATA[]]>
//	  </Text>
//	  <Offset>0</Offset>
//	</Line>
//	<Line>
//	  <Text>
//<![CDATA[]]>
//	  </Text>
//	  <Offset>0</Offset>
//	</Line>
//	<Line>
//	  <Text>
//<![CDATA[]]>
//	  </Text>
//	  <Offset>0</Offset>
//	</Line>
//	<Line>
//	  <Text>
//<![CDATA[]]>
//	  </Text>
//	  <Offset>0</Offset>
//	</Line>
//	<Line>
//	  <Text>
//<![CDATA[]]>
//	  </Text>
//	  <Offset>0</Offset>
//	</Line>
//</Lyrics>


struct Lyrics: XMLIndexerDeserializable {
	var dispatched: Bool

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Lyrics(
			dispatched: node.value(ofAttribute: "dispatched")
		)
	}
}
