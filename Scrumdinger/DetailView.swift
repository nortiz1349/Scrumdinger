//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/15.
//

import SwiftUI

struct DetailView: View {
	let scrum: DailyScrum
	
	@State private var isPresentingEditView = false
	
    var body: some View {
		List {
			Section(header: Text("미팅 정보")) {
				NavigationLink(destination: MeetingView()) {
					Label("미팅 시작하기", systemImage: "timer")
						.font(.headline)
					.foregroundColor(.accentColor)
				}
				HStack {
					Label("소요 시간", systemImage: "clock")
					Spacer()
					Text("\(scrum.lengthInMinutes) 분")
				}
				.accessibilityElement(children: .combine)
				HStack {
					Label("테마", systemImage: "paintpalette")
					Spacer()
					Text(scrum.theme.name)
						.padding(4)
						.foregroundColor(scrum.theme.accentColor)
						.background(scrum.theme.mainColor)
						.cornerRadius(4)
				}
			}
			Section(header: Text("참가자")) {
				ForEach(scrum.attendees) { attendee in
					Label(attendee.name, systemImage: "person")
				}
			}
		}
		.navigationTitle(scrum.title)
		.toolbar {
			Button("편집") {
				isPresentingEditView = true
			}
		}
		.sheet(isPresented: $isPresentingEditView) {
			NavigationStack {
				DetailEditView()
					.navigationTitle(scrum.title)
					.toolbar {
						ToolbarItem(placement: .cancellationAction) {
							Button("취소") {
								isPresentingEditView = false
							}
						}
						ToolbarItem(placement: .confirmationAction) {
							Button("완료") {
								isPresentingEditView = false
							}
						}
					}
			}
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			DetailView(scrum: DailyScrum.sampleData[0])
		}
    }
}
