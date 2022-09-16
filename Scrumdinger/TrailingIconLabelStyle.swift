//
//  TrailingIconLabelStyle.swift
//  Scrumdinger
//
//  Created by Nortiz M1 on 2022/09/15.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.title
			configuration.icon
		}
	}
}

extension LabelStyle where Self == TrailingIconLabelStyle {
	static var trailingIcon: Self { Self() }
}
