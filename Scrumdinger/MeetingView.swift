//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/14.
//

import SwiftUI

struct MeetingView: View {
    var body: some View {
		VStack {
			ProgressView(value: 5, total: 15)
			HStack {
				VStack(alignment: .leading) {
					Text("경과 시간")
						.font(.caption)
					Label("300", systemImage: "hourglass.bottomhalf.fill")
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("남은 시간")
						.font(.caption)
					Label("600", systemImage: "hourglass.tophalf.fill")
				}
			}
			.accessibilityElement(children: .ignore)
			.accessibilityLabel("남은 시간")
			.accessibilityValue("10 분")
			Circle()
				.strokeBorder(lineWidth: 24)
			HStack {
				Text("발표자 1 / 3")
				Spacer()
				Button(action: {}) {
					Image(systemName: "forward.fill")
				}
				.accessibilityLabel("다음 발표자")
			}
				
		}
		.padding()
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView()
    }
}
