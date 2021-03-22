//
//  StringParser.swift
//  mnc-import
//
//	Created by Steven Woolgar on 2021-02-24.
//	Copyright (c) 2021, Steven Woolgar
//

import Foundation

// MARK: Parser composable base

struct Parser<A> {
	let run: (inout Substring) -> A?
}

func literal(_ literal: String) -> Parser<Void> {
	return Parser<Void> { str in
		guard str.hasPrefix(literal) else { return nil }
		str.removeFirst(literal.count)
		return ()
	}
}
