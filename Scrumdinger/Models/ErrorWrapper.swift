//
//  ErrorWrapper.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/19.
//

import Foundation

struct ErrorWrapper: Identifiable {
	let id: UUID
	let error: Error
	let guidance: String
	
	init(id: UUID = UUID(), error: Error, guidance: String) {
		self.id = id
		self.error = error
		self.guidance = guidance
	}
}
