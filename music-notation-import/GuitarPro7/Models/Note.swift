//
//	Note.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

enum VibratoParseError: Error { case unsupportedVibratoValue(String) }

//	 <Vibrato>Slight</Step>
enum Vibrato: XMLIndexerDeserializable {
	case slight
	case wide

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let value: String = try node.value()

		switch value {
		case "Slight":	return .slight
		case "Wide":	return .wide
		default:
			throw VibratoParseError.unsupportedVibratoValue(value)
		}
	}
}

enum StepParseError: Error { case unsupportedStepValue(String) }

//	 <Step>G</Step>
enum Step: XMLIndexerDeserializable {
	case aPitch
	case bPitch
	case cPitch
	case dPitch
	case ePitch
	case fPitch
	case gPitch

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let value: String = try node.value()

		switch value {
		case "A":	return .aPitch
		case "B":	return .bPitch
		case "C":	return .cPitch
		case "D":	return .dPitch
		case "E":	return .ePitch
		case "F":	return .fPitch
		case "G":	return .gPitch
		default:
			throw StepParseError.unsupportedStepValue(value)
		}
	}
}

enum AccidentalParseError: Error { case unsupportedAccidentalValue(String) }

//	 <Accidental>#</Accidental>
enum Accidental: XMLIndexerDeserializable {
	case none
	case sharp
	case doubleSharp
	case flat
	case doubleFlat
	case natural

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let value: String = try node.value()

		switch value {
		case "":	return .none
		case "#":	return .sharp
		case "##":	return .doubleSharp
		case "b":	return .flat
		case "bb":	return .doubleFlat
		case "N":	return .natural
		default:
			throw AccidentalParseError.unsupportedAccidentalValue(value)
		}
	}
}

// <Pitch>
//	 <Step>G</Step>
//	 <Accidental>#</Accidental>
//	 <Octave>5</Octave>
// </Pitch>

struct Pitch: XMLIndexerDeserializable {
	var step: Step
	var accidental: Accidental
	var octave: Int

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Pitch(
			step: node["Step"].value(),
			accidental: node["Accidental"].value(),
			octave: node["Octave"].value()
		)
	}
}

// <NoteProperties>
//	<Property name="ConcertPitch">
//		<Pitch>
//			<Step>G</Step>
//			<Accidental>#</Accidental>
//			<Octave>5</Octave>
//		</Pitch>
//	</Property>
//	<Property name="Fret">
//		  <Fret>9</Fret>
//	</Property>
//	<Property name="Midi">
//		  <Number>68</Number>
//	</Property>
//	<Property name="String">
//		  <String>4</String>
//	</Property>
//	<Property name="TransposedPitch">
//		<Pitch>
//			<Step>G</Step>
//			<Accidental>#</Accidental>
//			<Octave>6</Octave>
//		</Pitch>
// <Property name="BendDestinationOffset">
//  <Float>99.000000</Float>
// </Property>
// <Property name="BendDestinationValue">
//  <Float>100.000000</Float>
// </Property>
// <Property name="BendMiddleOffset1">
//  <Float>12.000000</Float>
// </Property>
// <Property name="BendMiddleOffset2">
//  <Float>12.000000</Float>
// </Property>
// <Property name="BendMiddleValue">
//  <Float>50.000000</Float>
// </Property>
// <Property name="BendOriginOffset">
//  <Float>0.000000</Float>
// </Property>
// <Property name="BendOriginValue">
//  <Float>0.000000</Float>
// </Property>
//    </Property>
// </NoteProperties>

enum NotePropertyParseError: Error { case unsupportedPropertyAttribute(String) }

enum NoteProperty: XMLIndexerDeserializable {
	case concertPitch(Pitch)
	case fret(Int)
	case midi(Int)
	case string(Int)
	case transposedPitch(Pitch)
	case harmonic(Bool)
	case harmonicFret(Float)
	case harmonicType(String)
	case hopoOrigin(Bool)
	case hopoDestination(Bool)
	case muted(Bool)
	case slide(Int)
	case bend(Bool)
	case bendDestinationOffset(Float)
	case bendDestinationValue(Float)
	case bendMiddleOffset1(Float)
	case bendMiddleOffset2(Float)
	case bendMiddleValue(Float)
	case bendOriginOffset(Float)
	case bendOriginValue(Float)

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let propertyAttribute: String = try node.value(ofAttribute: "name")

		switch propertyAttribute {
		case "ConcertPitch":			return .concertPitch(try node["Pitch"].value())
		case "Fret":					return .fret(try node["Fret"].value())
		case "Midi":					return .midi(try node["Number"].value())
		case "String":					return .string(try node["String"].value())
		case "TransposedPitch":			return .transposedPitch(try node["Pitch"].value())
		case "Harmonic":				return .harmonic(node["Enable"].element != nil)
		case "HarmonicFret":			return .harmonicFret(try node["HFret"].value())
		case "HarmonicType":			return .harmonicType(try node["HType"].value())
		case "HopoOrigin":				return .hopoOrigin(node["Enable"].element != nil)
		case "HopoDestination":			return .hopoDestination(node["Enable"].element != nil)
		case "Muted":					return .muted(node["Enable"].element != nil)
		case "Slide":					return .muted(try node["Flags"].value())
		case "Bended":					return .bend(node["Enable"].element != nil)
		case "BendDestinationOffset":	return .bendDestinationOffset(try node["Float"].value())
		case "BendDestinationValue":	return .bendDestinationValue(try node["Float"].value())
		case "BendMiddleOffset1":		return .bendMiddleOffset1(try node["Float"].value())
		case "BendMiddleOffset2":		return .bendMiddleOffset2(try node["Float"].value())
		case "BendMiddleValue":			return .bendMiddleValue(try node["Float"].value())
		case "BendOriginOffset":		return .bendOriginOffset(try node["Float"].value())
		case "BendOriginValue":			return .bendOriginValue(try node["Float"].value())

		default:
			throw NotePropertyParseError.unsupportedPropertyAttribute(propertyAttribute)
		}
	}
}

//  <Tie origin="true" destination="false" />

struct Tie: XMLIndexerDeserializable {
	var origin: Bool
	var destination: Bool

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Tie(
			origin: node.value(ofAttribute: "origin"),
			destination: node.value(ofAttribute: "destination")
		)
	}
}

// <Note id="0">
//  <Tie origin="true" destination="false" />
//  <InstrumentArticulation>0</InstrumentArticulation>
//  <Properties>
//	<Property name="ConcertPitch">
//	  <Pitch>
//		<Step>E</Step>
//		<Accidental></Accidental>
//		<Octave>3</Octave>
//	  </Pitch>
//	</Property>
//	<Property name="Fret">
//	  <Fret>-24</Fret>
//	</Property>
//	<Property name="Midi">
//	  <Number>40</Number>
//	</Property>
//	<Property name="String">
//	  <String>5</String>
//	</Property>
//	<Property name="TransposedPitch">
//	  <Pitch>
//		<Step>E</Step>
//		<Accidental></Accidental>
//		<Octave>3</Octave>
//	  </Pitch>
//	</Property>
//  </Properties>
// </Note>

var noteCount = 0
var tieCount = 0
var accentCount = 0
var antiAccentCount = 0
var vibratoCount = 0
var letRingCount = 0

struct Note: XMLIndexerDeserializable {
	var id: Int
	var tie: Tie?
	var accent: Int?
	var antiAccent: String?
	var vibrato: Vibrato?
	var letRing: Bool?
	var instrumentArticulation: Int
	var properties: [NoteProperty]

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		let note = try Note(
			id: node.value(ofAttribute: "id"),
			tie: node["Tie"].value(),
			accent: node["Accent"].value(),
			antiAccent: node["AntiAccent"].value(),
			vibrato: node["Vibrato"].value(),
			letRing: node["LetRing"].element != nil ? true : nil,
			instrumentArticulation: node["InstrumentArticulation"].value(),
			properties: node["Properties"]["Property"].value()
		)

		noteCount += 1
		if note.tie != nil { tieCount += 1 }
		if note.accent != nil { accentCount += 1 }
		if note.antiAccent != nil { antiAccentCount += 1 }
		if note.vibrato != nil { vibratoCount += 1 }
		if note.letRing != nil { letRingCount += 1 }

		assert(!(node.children.count == 3 && note.tie == nil && note.vibrato == nil && note.accent == nil && note.antiAccent == nil && note.letRing == nil),
				 "unhandled child")

		return note
	}
}
