//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/16.
//

import Foundation

/// 일일 스크럼 회의를 위한 시간을 유지합니다. 총 회의 시간, 각 발언자의 시간 및 현재 발언자의 이름을 추적합니다.
class ScrumTimer: ObservableObject {
	/// 회의 중에 회의 참석자를 추적하는 구조체입니다.
	struct Speaker: Identifiable {
		/// 참석자 이름
		let name: String
		/// 참석자가 발언을 완료하면 true
		var isCompleted: Bool
		/// Identifiable 프로토콜 준수 ID
		let id = UUID()
	}
	
	/// 말하고 있는 회의 참석자의 이름입니다.
	@Published var activeSpeaker = ""
	/// 회의 시작 이후 경과된 시간(초)입니다.
	@Published var secondsElapsed = 0
	/// 모든 참석자가 발언할 차례가 될 때까지 남은 시간(초)입니다.
	@Published var secondsRemaining = 0
	///  회의 참석자, 발언 순서대로 리스트에 들어 있습니다.
	private(set) var speakers: [Speaker] = []
	
	/// 스크럼 회의의 길이(분)
	private(set) var lengthInMinutes: Int
	/// 새로운 참석자가 말하기 시작할 때 실행되는 클로저입니다.
	var speakerChangedAction: (() -> Void)?
	
	private var timer: Timer?
	private var timerStopped = false
	private var frequency: TimeInterval { 1.0 / 60.0 }
	private var lengthInSeconds: Int { lengthInMinutes * 60 }
	private var secondsPerSpeaker: Int {
		(lengthInMinutes * 60) / speakers.count
	}
	private var secondsElapsedForSpeaker: Int = 0
	private var speakerIndex: Int = 0
	private var speakerText: String {
		return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
	}
	private var startDate: Date?
	
	/**
	 새 타이머를 초기화합니다. 인수 없이 시간을 초기화하면 참석자가 없고 길이가 0인 ScrumTimer가 생성됩니다.
	 타이머를 시작하려면 `startScrum()`을 사용하세요.
	 
	 - Parameters:
		- lengthInMinutes: 회의 길이(분)
		- attendees: 회의 참석자 리스트
	 */
	init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
		self.lengthInMinutes = lengthInMinutes
		self.speakers = attendees.speakers
		secondsRemaining = lengthInSeconds
		activeSpeaker = speakerText
	}
	
	/// 타이머 시작
	func startScrum() {
		changeToSpeaker(at: 0)
	}
	
	/// 타이머 멈춤
	func stopScrum() {
		timer?.invalidate()
		timer = nil
		timerStopped = true
	}
	
	func skipSpeaker() {
		changeToSpeaker(at: speakerIndex + 1)
	}
	
	private func changeToSpeaker(at index: Int) {
		if index > 0 {
			let previousSpeakerIndex = index - 1
			speakers[previousSpeakerIndex].isCompleted = true
		}
		secondsElapsedForSpeaker = 0
		guard index < speakers.count else { return }
		speakerIndex = index
		activeSpeaker = speakerText
		
		secondsElapsed = index * secondsPerSpeaker
		secondsRemaining = lengthInSeconds - secondsElapsed
		startDate = Date()
		timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
			if let self = self, let startDate = self.startDate {
				let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
				self.update(secondsElapsed: Int(secondsElapsed))
			}
		}
	}
	
	private func update(secondsElapsed: Int) {
		secondsElapsedForSpeaker = secondsElapsed
		self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
		guard secondsElapsed <= secondsPerSpeaker else { return }
		secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
		
		guard !timerStopped else { return }
		
		if secondsElapsedForSpeaker >= secondsPerSpeaker {
			changeToSpeaker(at: speakerIndex + 1)
			speakerChangedAction?()
		}
	}
	
	/**
	 새로운 회의 시간과 참석자가 있을 경우 리셋 타이머
	 */
	func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
		self.lengthInMinutes = lengthInMinutes
		self.speakers = attendees.speakers
		secondsRemaining = lengthInSeconds
		activeSpeaker = speakerText
	}
}

extension DailyScrum {
	/// DailyScrum 에서 새로운 회의길이와 참석자를 사용하는 새 ScrumTimer
	var timer: ScrumTimer {
		ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
	}
}

extension Array where Element == DailyScrum.Attendee {
	var speakers: [ScrumTimer.Speaker] {
		if isEmpty {
			return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
		} else {
			return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
		}
	}
}
