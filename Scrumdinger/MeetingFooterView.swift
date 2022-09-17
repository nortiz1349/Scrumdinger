//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/17.
//

import SwiftUI

struct MeetingFooterView: View {
	let speakers: [ScrumTimer.Speaker]
	var skipAction: ()->Void
	
	/// 현재 발언자 번호를 반환합니다.
	private var speakerNumber: Int? {
		guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil }
		return index + 1
	}
	/// 마지막 발언자인지 확인합니다.
	private var isLastSpeaker: Bool {
		// 마지막 발언자를 제외하고 나머지의 isCompleted 속성이 true인 경우 이 속성은 true입니다.
		return speakers.dropLast().allSatisfy { $0.isCompleted }
	}
	private var speakerText: String {
		guard let speakerNumber = speakerNumber else { return "발언자가 더 이상 없습니다." }
		return "발언자 \(speakerNumber) / \(speakers.count)"
	}
	
    var body: some View {
		VStack {
			HStack {
				if isLastSpeaker {
					Text("마지막 발언자")
				} else {
					Text(speakerText)
					Spacer()
					Button(action: skipAction) {
						Image(systemName: "forward.fill")
					}
					.accessibilityLabel("다음 발언자")
				}
			}
		}
		.padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
		MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
			.previewLayout(.sizeThatFits)
    }
}
