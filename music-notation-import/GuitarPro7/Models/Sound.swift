//
//	Sound.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

// <Sound>
//   <Name>
// <![CDATA[Geddy Lee Vocals - Xanadu]]>
//   </Name>
//   <Label>
// <![CDATA[Geddy Lee]]>
//   </Label>
//   <Path>Orchestra/Keyboard/Electric Piano</Path>
//   <Role>User</Role>
//   <MIDI>
//	 <LSB>0</LSB>
//	 <MSB>0</MSB>
//	 <Program>53</Program>
//   </MIDI>
//   <RSE>
//	 <SoundbankPatch>MarkI-EPiano</SoundbankPatch>
//	 <Pickups>
//	   <OverloudPosition>0</OverloudPosition>
//	   <Volumes>1 1</Volumes>
//	   <Tones>1 1</Tones>
//	 </Pickups>
//	 <EffectChain>
//	   <Effect id="M08_GraphicEQ10Band">
//       <Parameters>1 1 0.25 0.5 0.5 0.5 0.5 0.346939 0.612245 0.632653 0.5 0.693878 0.5</Parameters>
// 	   </Effect>
// 	   <Effect id="M13_ModulationDigitalChorus">
// 		 <Parameters>0.28 0.5 0.5 0.64</Parameters>
//	   </Effect>
//	   <Effect id="M07_DynamicClassicDynamic">
//		 <Parameters>0.77 0.5 0.3209</Parameters>
//	   </Effect>
//	   <Effect id="M02_StudioReverbHallSmallTheater">
//	     <Parameters>1 0.43 0.27 0.37 0.6</Parameters>
//	   </Effect>
//	   <Effect />
//	   <Effect />
//	 </EffectChain>
//  </RSE>
// </Sound>

struct Sound: XMLIndexerDeserializable {
	var name: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Sound(
			name: node["Name"].value()
		)
	}
}
