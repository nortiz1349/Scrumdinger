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
	@State private var errorWrapper: ErrorWrapper?
	
	var body: some Scene {
		WindowGroup {
			NavigationView {
				ScrumsView(scrums: $store.scrums) {
					Task {
						do {
							try await ScrumStore.save(scrums: store.scrums)
						} catch {
							errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
						}
					}
				}
			}
			.task {
				do {
					store.scrums = try await ScrumStore.load()
				} catch {
					errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
				}
			}
			.sheet(item: $errorWrapper) {
				store.scrums = DailyScrum.sampleData
			} content: { wrapper in
				ErrorView(errorWrapper: wrapper)
			}

		}
	}
}
