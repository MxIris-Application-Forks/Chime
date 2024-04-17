import AppKit
import SwiftUI

import DocumentContent
import Status
import Theme
import UIUtility

@MainActor
struct EditorContent<Content: View>: View {
	@Environment(EditorStateModel.self) private var model
	@Environment(\.theme) private var theme
	@Environment(\.controlActiveState) private var controlActiveState
	@Environment(\.colorScheme) private var colorScheme
	@State private var statusBarVisible = true

	let content: Content

	init(_ content: () -> Content) {
		self.content = content()
	}

	private var context: Theme.Context {
		.init(controlActiveState: controlActiveState, hover: false, colorScheme: colorScheme)
	}

	// also does not explicitly ignore safe areas, which ensures the titlebar is respected
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			content
			if statusBarVisible {
				StatusBar()
					.transition(.move(edge: .bottom))
			}
		}
		.background(Color(theme.color(for: .background, context: context)))
		.environment(\.documentCursors, model.cursors)
		.environment(\.editorVisibleRect, model.visibleFrame)
		.environment(\.statusBarPadding, model.contentInsets)
		.onChange(of: model.statusBarVisible) {
			withAnimation(.easeIn(duration: 0.2)) {
				statusBarVisible.toggle()
			}
		}
	}
}
