//
//	Staff.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

// <Staff>
//  <Properties>
//	<Property name="CapoFret"><Fret>0</Fret></Property>
//	<Property name="FretCount"><Number>24</Number></Property>
//	<Property name="PartialCapoFret"><Fret>0</Fret></Property>
//	<Property name="PartialCapoStringFlags"><Bitset>000000</Bitset></Property>
//	<Property name="Tuning"><Pitches>40 45 50 55 59 64</Pitches><Flat></Flat><Instrument>Guitar</Instrument><Label><![CDATA[]]></Label><LabelVisible>true</LabelVisible></Property>
//	<Property name="ChordCollection"><Items /></Property>
//	<Property name="ChordWorkingSet"><Items /></Property>
//	<Property name="DiagramCollection"><Items /></Property>
//	<Property name="DiagramWorkingSet"><Items /></Property>
//	<Property name="TuningFlat"><Enable /></Property>
//	<Name><![CDATA[Standard]]></Name>
//  </Properties>
// </Staff>

typealias TuningPitch = Int

enum StaffPropertyParseError: Error {
	case unsupportedPropertyAttribute(String)
}

struct StaffPropertyItem: XMLIndexerDeserializable {
	static func deserialize(_ node: XMLIndexer) throws -> Self {
		StaffPropertyItem(
		)
	}
}

enum StaffProperty: XMLIndexerDeserializable {
	case capoFret(Int)
	case fretCount(Int)
	case partialCapoFret(Int)
	case partialCapoStringFlags(String)
	case tuning(pitches: [TuningPitch], flat: Int?, instrument: String, label: String, labelVisible: Bool)
	case chordCollection([StaffPropertyItem])
	case chordWorkingSet([StaffPropertyItem])
	case diagramCollection([StaffPropertyItem])
	case diagramWorkingSet([StaffPropertyItem])
	case tuningFlat(Bool)

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let propertyAttribute: String = try node.value(ofAttribute: "name")

		switch propertyAttribute {
		case "CapoFret":
			return .capoFret(try node["Fret"].value())
		case "FretCount":
			return .fretCount(try node["Number"].value())
		case "PartialCapoFret":
			return .partialCapoFret(try node["Fret"].value())
		case "PartialCapoStringFlags":
			return .partialCapoStringFlags(try node["Bitset"].value())
		case "Tuning":
			let pitchesString: String = try node["Pitches"].value()
			let pitchesArray = pitchesString.split(separator: " ")
			let pitches = pitchesArray.compactMap { Int($0) }

			let flat: String = try node["Flat"].value()

			return .tuning(pitches: pitches,
						   flat: Int(flat),
						   instrument: try node["Instrument"].value(),
						   label: try node["Label"].value(),
						   labelVisible: try node["LabelVisible"].value())
		case "ChordCollection":
			return .chordCollection([])
		case "ChordWorkingSet":
			return .chordWorkingSet([])
		case "DiagramCollection":
			return .diagramCollection([])
		case "DiagramWorkingSet":
			return .diagramWorkingSet([])
		case "TuningFlat":
			return .tuningFlat(node["Enable"].element != nil)
		default:
			throw StaffPropertyParseError.unsupportedPropertyAttribute(propertyAttribute)
		}
	}
}

// NB: The <Properties> array is malformed XML in that it isn't just a list of <Property> entries, but also
// contains a <Name> entry. I will have to manually pull all of array entries out and then the <Name>.
struct Staff: XMLIndexerDeserializable {
	var properties: [StaffProperty]
	var name: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Staff(
			properties: node["Properties"]["Property"].value(),
			name: node["Properties"]["Name"].value()
		)
	}
}
