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
					ScrumStore.save(scrums: store.scrums) { result in
						if case .failure(let failure) = result {
							fatalError(failure.localizedDescription)
						}
					}
				}
			}
			.onAppear {
				ScrumStore.load { result in
					switch result {
					case .failure(let error):
						fatalError(error.localizedDescription)
					case .success(let scrums):
						store.scrums = scrums
					}
				}
			}
		}
	}
}
