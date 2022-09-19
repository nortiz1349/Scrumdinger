//
//  History.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/17.
//

import Foundation

struct History: Identifiable, Codable {
	let id: UUID
	let date: Date
	var attendees: [DailyScrum.Attendee]
	var lengthInMinutes: Int
	var transcript: String?
	
	init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], lengthInMinutes: Int = 5, transcript: String? = nil) {
		self.id = id
		self.date = date
		self.attendees = attendees
		self.lengthInMinutes = lengthInMinutes
		self.transcript = transcript
	}
}
