//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/14.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
	@State private var scrums = DailyScrum.sampleData
	
	var body: some Scene {
		WindowGroup {
			NavigationView {
				ScrumsView(scrums: $scrums)
			}
		}
	}
}
