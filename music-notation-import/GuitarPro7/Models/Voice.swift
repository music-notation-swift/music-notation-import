//
//	Voice.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-09.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

// <Voice id="0">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="1">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="2">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="3">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="4">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="5">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="6">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="7">
//  <Beats>2</Beats>
// </Voice>
// <Voice id="8">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="9">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="10">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="11">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="12">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="13">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="14">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="15">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="16">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="17">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="18">
//  <Beats>3</Beats>
// </Voice>
// <Voice id="19">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="20">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="21">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="22">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="23">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="24">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="25">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="26">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="27">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="28">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="29">
//  <Beats>3</Beats>
// </Voice>
// <Voice id="30">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="31">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="32">
//  <Beats>1</Beats>
// </Voice>
// <Voice id="33">
//  <Beats>0</Beats>
// </Voice>
// <Voice id="34">
//  <Beats>4 5 6 7 8 9</Beats>
// </Voice>

struct Voice: XMLIndexerDeserializable {
	var id: Int
	var beats: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Voice(
			id: node.value(ofAttribute: "id"),
			beats: node["Beats"].value()
		)
	}
}
