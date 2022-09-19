//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/15.
//

import SwiftUI

struct DetailView: View {
	@Binding var scrum: DailyScrum
	
	@State private var data = DailyScrum.Data()
	@State private var isPresentingEditView = false
	
    var body: some View {
		List {
			Section(header: Text("회의 정보")) {
				NavigationLink(destination: MeetingView(scrum: $scrum)) {
					Label("회의 시작하기", systemImage: "timer")
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
			Section(header: Text("회의 기록")) {
				if scrum.history.isEmpty {
					Label("진행된 회의가 없습니다.", systemImage: "calendar.badge.exclamationmark")
				}
				ForEach(scrum.history) { history in
					NavigationLink(destination: HistoryView(history: history)) {
						HStack {
							Image(systemName: "calendar")
							Text(history.date, style: .date)
						}
					}
				}
			}
		}
		.navigationTitle(scrum.title)
		.toolbar {
			Button("편집") {
				isPresentingEditView = true
				data = scrum.data
			}
		}
		.sheet(isPresented: $isPresentingEditView) {
			NavigationView {
				DetailEditView(data: $data)
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
								scrum.update(from: data)
							}
						}
					}
			}
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			DetailView(scrum: .constant(DailyScrum.sampleData[0]))
		}
    }
}
