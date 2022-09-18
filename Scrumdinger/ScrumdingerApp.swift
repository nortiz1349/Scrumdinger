//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/14.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
//	@State private var scrums = DailyScrum.sampleData
	@StateObject private var store = ScrumStore()
	
	var body: some Scene {
		WindowGroup {
			NavigationView {
				ScrumsView(scrums: $store.scrums) {
					Task {
						do {
							try await ScrumStore.save(scrums: store.scrums)
						} catch {
							fatalError("Error saving scrums.")
						}
					}
				}
			}
			.task {
				do {
					store.scrums = try await ScrumStore.load()
				} catch {
					fatalError("Error loading scrums.")
				}
			}
		}
	}
}
