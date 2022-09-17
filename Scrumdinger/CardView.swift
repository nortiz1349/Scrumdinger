//
//  CardView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/15.
//

import SwiftUI

struct CardView: View {
	let scrum: DailyScrum
	
    var body: some View {
		VStack(alignment: .leading) {
			Text(scrum.title)
				.font(.headline)
				.accessibilityAddTraits(.isHeader)
			Spacer()
			HStack {
				Label("\(scrum.attendees.count)", systemImage: "person.3")
					.accessibilityLabel("참가자 \(scrum.attendees.count) 명")
				Spacer()
				Label("\(scrum.lengthInMinutes)", systemImage: "clock")
					.accessibilityLabel("회의 시간 \(scrum.lengthInMinutes) 분")
					.labelStyle(.trailingIcon)
			}
			.font(.caption)
		}
		.padding()
		.foregroundColor(scrum.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
	static var scrum = DailyScrum.sampleData[0]
    static var previews: some View {
		CardView(scrum: scrum)
			.background(scrum.theme.mainColor)
			.previewLayout(.fixed(width: 400, height: 60))
    }
}
