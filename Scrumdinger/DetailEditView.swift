//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/15.
//

import SwiftUI

struct DetailEditView: View {
	@State private var data = DailyScrum.Data()
	@State private var newAttendeeName = ""
	
    var body: some View {
		Form {
			Section(header: Text("미팅 정보")) {
				TextField("제목", text: $data.title)
				HStack {
					Slider(value: $data.lengthInMinute, in: 5...30, step: 1) {
						Text("길이")
					}
					.accessibilityLabel("\(Int(data.lengthInMinute)) 분")
					Spacer()
					Text("\(Int(data.lengthInMinute)) 분")
						.accessibilityHidden(true)
				}
			}
			Section(header: Text("참가자")) {
				ForEach(data.attendees) { attendee in
					Text(attendee.name)
				}
				.onDelete { indices in
					data.attendees.remove(atOffsets: indices)
				}
				HStack {
					TextField("참가자 추가하기", text: $newAttendeeName)
					Button(action: {
						withAnimation {
							let attendee = DailyScrum.Attendee(name: newAttendeeName)
							data.attendees.append(attendee)
							newAttendeeName = ""
						}
					}) {
						Image(systemName: "plus.circle.fill")
							.accessibilityLabel("참가자 추가하기")
					}
					.disabled(newAttendeeName.isEmpty)
				}
			}
		}
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView()
    }
}
