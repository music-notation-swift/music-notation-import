//
//	TimeSignature.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-23.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

// <Time>4/4</Time>
//
// <Time>7/8</Time>
//
// <Time>23/3</Time>

enum TimeSignatureError: Error {
	case timeSignatureParseError(String)
	case unsupportedTimeSignature(String)
	case beatsPerBarNotInteger(String)
	case beatUnitNotInteger(String)
}

/// The time signature (also known as `meter signature`, `metre signature`, or `measure signature`) is a notational convention used
/// in Western musical notation to specify how many beats (pulses) are contained in each measure (bar), and which note value
/// is equivalent to a beat.
///
/// In a music score, the time signature appears at the beginning as a time symbol or stacked numerals, such as common time
/// or `3/4` (read common time and three-four time, respectively), immediately following the key signature (or immediately
/// following the clef symbol if the key signature is empty). A mid-score time signature, usually immediately following a
/// barline, indicates a change of meter.
///
/// There are various types of time signatures, depending on whether the music follows regular (or symmetrical) beat patterns,
/// including simple (e.g., `3/4` and `4/4`), and compound (e.g., `9/8` and `12/8`); or involves shifting beat patterns, including
/// complex (e.g., `5/4` or `7/8`), odd (e.g., `5/8` & `3/8` or `6/8` & `3/4`), additive (e.g., `3 + 2/8 + 3`),
/// fractional (e.g., ​`2½/4`), and complex meters (e.g., `3/10` or `5/24`).
///
/// - Note:
///		A regular (`.simple`, `.compound`) time signature is one which represents 2, 3 or 4 main beats per bar.
///		- **Duple** time means 2 main beats per bar
///		- **Triple** time means 3 main beats per bar
///		- **Quadruple**` time means 4 main beats per bar
///
///		`.simple` time signatures have a main beat which divides into **two** 1st level sub-beats.
///		`.compound` time signatures have a main beat which divides into **three** 1st level sub-beats.
///		In both `.simple` and `.compound` time, 2nd level sub-beats always subdivide by two (never by three).
///
///
///	# Meter and time signatures #
///
///	Meter involves the way multiple pulse layers work together to organize music in time. Standard meters in Western
///	music can be classified into _simple meters_ and _compound meters_, as well as _duple_, _triple_, and _quadruple meters_.
///
///	Duple, triple, and quadruple classifications result from the relationship between the counting pulse and the pulses
///	that are slower than the counting pulse. In other words, it is a question of grouping: how many beats occur in each bar.
///	If counting-pulse beats group into twos, we have duple meter; groups of three, triple meter; groups of four,
///	quadruple meter. Conducting patterns are determined based on these classifications.
///
///	Simple and compound classifications result from the relationship between the counting pulse and the pulses that are
///	faster than the counting pulse. In other words, it is a question of division: does each beat divide into two equal
///	parts, or three equal parts. Meters that divide the beat into two equal parts are simple meters; meters that divide
///	the beat into three equal parts are compound meters.
///
///	Thus, there are six types of standard meter in Western music:
///
///	- simple duple (beats group into two, divide into two)
///	- simple triple (beats group into three, divide into two)
///	- simple quadruple (beats group into four, divide into two)
///	- compound duple (beats group into two, divide into three)
///	- compound triple (beats group into three, divide into three)
///	- compound quadruple (beats group into four, divide into three)
///
///	In a time signature, the top number (and the top number only!) describes the type of meter. Following are the top
///	numbers that always correspond to each type of meter:
///
///	- simple duple: 2
///	- simple triple: 3
///	- simple quadruple: 4
///	- compound duple: 6
///	- compound triple: 9
///	- compound quadruple: 12
///
///	## Notating meter ##
///
/// As far as I can tell, there can be little to infer about a meter from simply the time signature (especially it's odd'ness).
/// For example, 8/8 is an odd meter which is counted as **1**-2-3, **2**-2-3, **3**-2 and 4/4 would be **1** &, **2** &, **3** &, **4** &.
/// And yet 9/8 is an even meter (**1**-2-3, **2**-2-3, **3**-2-3)
///
///	In _simple meters_, the bottom number of the time signature corresponds to the type of note corresponding to a
///	single beat. If a simple meter is notated such that each quarter note corresponds to a beat, the bottom
///	number of the time signature is 4. If a simple meter is notated such that each half note corresponds
///	to a beat, the bottom number of the time signature is 2. If a simple meter is notated such that each eighth
///	note corresponds to a beat, the bottom number of the time signature is 8. And so on.
///
///	In _compound meters_, the bottom number of the time signature corresponds to the type of note corresponding to
///	a _single division of the beat_. If a compound meter is notated such that each dotted-quarter note corresponds to
///	a beat, the eighth note is the division of the beat, and thus the bottom number of the time signature is 8.
///	If a compound meter is notated such that each dotted-half note corresponds to a beat, the quarter note is the
///	division of the beat, and thus the bottom number of the time signature is 4. Note that because the beat is
///	divided into three in a compound meter, the beat is always three times as long as the division note, and
///	_the beat is always dotted_.

enum TimeSignature: XMLIndexerDeserializable {
	case simple(_ beatsPerBar: Int, _ beatUnit: Int)		// `2/4`, `3/4`, `4/4`, `common` and `cut-common`
	case compound(_ beatsPerBar: Int, _ beatUnit: Int)		// `9/8` and `12/8`
	case additive(_ beatsPerBar: [Int], _ beatUnit: Int)	// `3 + 2/8 + 3` (NB: I have seen `3/8 & 2/8`)
	case fractional(_ beatsPerBar: Float, _ beatUnit: Int)	// `2½/4`
	case complex(_ beatsPerBar: Int, _ beatUnit: Int)	// `3/10`, `5/24`

	// `5/4`, `7/8`, `11/16`, `8/8`
	func oddMeter() -> Bool {
		switch self {
		case let .simple(beatsPerBar, beatUnit), let .compound(beatsPerBar, beatUnit), let .complex(beatsPerBar, beatUnit):
			switch (beatsPerBar, beatUnit) {
			case (5, 4), (7, 4), (7, 8), (8, 8), (5, 8), (11, 8):
				return true
			case (let beatsPerBar, 16):
				return beatsPerBar % 2 != 0
			default:
				return false
			}
		default:
			return false
		}
	}

	static func type(from: String) throws -> Self {
		var timeSignatureSubstring = from[...]
		guard let timeSignature = timeSignatureParse.run(&timeSignatureSubstring) else { throw TimeSignatureError.timeSignatureParseError(from) }
		return timeSignature
	}

	/// Based on the provided parameters, determine what kind of regular type the time signature represents.
	/// - Note: This is not meant for `.fractional` or `.additive` time signatures.
	/// TODO: This is not a good way to determine the type. It should be calculated based on rules instead of a list of
	/// cases that fit in each bucket.
	static func commonType(beatsPerBar: Int, beatUnit: Int) -> Self {
		switch (beatsPerBar, beatUnit) {
		case (2, 4), (3, 4), (4, 4), (_, 4):
			return .simple(beatsPerBar, beatUnit)
		case (6, 8), (9, 8), (12, 8), (_, 8):
			return .compound(beatsPerBar, beatUnit)
		default:
			return .complex(beatsPerBar, beatUnit)
		}
	}

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try TimeSignature.type(from: try node.value())
	}
}

// MARK: - Equality Support
extension TimeSignature: Equatable {
	public static func == (lhs: TimeSignature, rhs: TimeSignature) -> Bool {
		switch (lhs, rhs) {
		case let (.simple(lhsBeatsPerBar, lhsBeatUnit), .simple(rhsBeatsPerBar, rhsBeatUnit)) where lhsBeatsPerBar == rhsBeatsPerBar && lhsBeatUnit == rhsBeatUnit:
			return true
		case let (.compound(lhsBeatsPerBar, lhsBeatUnit), .compound(rhsBeatsPerBar, rhsBeatUnit)) where lhsBeatsPerBar == rhsBeatsPerBar && lhsBeatUnit == rhsBeatUnit:
			return true
		case let (.additive(lhsBeatsPerBar, lhsBeatUnit), .additive(rhsBeatsPerBar, rhsBeatUnit)) where lhsBeatsPerBar == rhsBeatsPerBar && lhsBeatUnit == rhsBeatUnit:
			return true
		case let (.fractional(lhsBeatsPerBar, lhsBeatUnit), .fractional(rhsBeatsPerBar, rhsBeatUnit)) where lhsBeatsPerBar == rhsBeatsPerBar && lhsBeatUnit == rhsBeatUnit:
			return true
		case let (.complex(lhsBeatsPerBar, lhsBeatUnit), .complex(rhsBeatsPerBar, rhsBeatUnit)) where lhsBeatsPerBar == rhsBeatsPerBar && lhsBeatUnit == rhsBeatUnit:
			return true
		default:
			return false
		}
	}
}

// MARK: - Time Signature String Parsing

// Used to find and consume `5` in a time signature like `5/4`.
let int = Parser<Int> { str in
	let prefix = str.prefix(while: { $0.isNumber })
	let match = Int(prefix)
	str.removeFirst(prefix.count)
	return match
}

// Used to find and consume `2.5` in a time signature like `2.5/4`.
let float = Parser<Float> { str in
	let prefix = str.prefix(while: { $0.isNumber || $0 == "." })
	let match = Float(prefix)
	str.removeFirst(prefix.count)
	return match
}

let timeSignatureParse = Parser<TimeSignature> { str in
	if str.contains("+") {			// Check for additive signature (`3+2/8+3`)
		let beatGroupingStrings = str.split(separator: "+")

		var beatGroupings = [Int]()
		var beatUnits: Int = 0

		for group in beatGroupingStrings {
			if group.contains("/") {
				let components = group.split(separator: "/")
				guard components.count == 2 else { return nil }
				guard let beatGroupingInt = Int(components[0]),
					  let beatUnitsInt = Int(components[1])
				else { return nil }

				beatGroupings.append(beatGroupingInt)
				beatUnits = beatUnitsInt
			} else {
				guard let beatGroupingInt = Int(group) else { return nil }
				beatGroupings.append(beatGroupingInt)
			}
		}

		return beatUnits == 0 ? nil : TimeSignature.additive(beatGroupings, beatUnits)

	} else if str.contains(".") {	// Check for fractional signature (`2.5/4`)
		guard let beatsPerBar = float.run(&str),
			  literal("/").run(&str) != nil,
			  let beatUnit = int.run(&str)
		else { return nil }

		return TimeSignature.fractional(beatsPerBar, beatUnit)

	} else {						// Parse one of the normal signatures
		guard let beatsPerBar = int.run(&str),
			  literal("/").run(&str) != nil,
			  let beatUnit = int.run(&str)
		else { return nil }

		return TimeSignature.commonType(beatsPerBar: beatsPerBar, beatUnit: beatUnit)
	}
}
