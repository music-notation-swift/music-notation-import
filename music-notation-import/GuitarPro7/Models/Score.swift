//
//	Score.swift
//	music-notation-import
//
//	Created by Steven Woolgar on 2021-02-10.
//	Copyright © 2020-2021 Steven Woolgar. All rights reserved.
//

import Foundation
import SWXMLHash

struct Score: XMLIndexerDeserializable {
	var title: String
	var subtitle: String
	var artist: String
	var album: String
	var words: String
	var music: String
	var wordsAndMusic: String
	var copyright: String
	var tabber: String
	var instructions: String
	var notices: String
	var firstPageHeader: String
	var firstPageFooter: String
	var pageHeader: String
	var pageFooter: String
	var systemsDefaultLayout: Int
	var systemsLayout: Int
	var zoomPolicy: String
	var zoom: Float
	var multiVoice: String

	static func deserialize(_ node: XMLIndexer) throws -> Self {
		try Score(
			title: node["Title"].value(),
			subtitle: node["SubTitle"].value(),
			artist: node["Artist"].value(),
			album: node["Album"].value(),
			words: node["Words"].value(),
			music: node["Music"].value(),
			wordsAndMusic: node["WordsAndMusic"].value(),
			copyright: node["Copyright"].value(),
			tabber: node["Tabber"].value(),
			instructions: node["Instructions"].value(),
			notices: node["Notices"].value(),
			firstPageHeader: node["FirstPageFooter"].value(),
			firstPageFooter: node["FirstPageFooter"].value(),
			pageHeader: node["PageHeader"].value(),
			pageFooter: node["PageFooter"].value(),
			systemsDefaultLayout: node["ScoreSystemsDefaultLayout"].value(),
			systemsLayout: node["ScoreSystemsLayout"].value(),
			zoomPolicy: node["ScoreZoomPolicy"].value(),
			zoom: node["ScoreZoom"].value(),
			multiVoice: node["MultiVoice"].value()
		)
	}
}
