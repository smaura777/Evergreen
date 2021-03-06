//
//  TimelineTableCellView.swift
//  Evergreen
//
//  Created by Brent Simmons on 8/31/15.
//  Copyright © 2015 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSTextDrawing

class TimelineTableCellView: NSTableCellView {

	let titleView = RSMultiLineView(frame: NSZeroRect)
	let unreadIndicatorView = UnreadIndicatorView(frame: NSZeroRect)
	let dateView = RSSingleLineView(frame: NSZeroRect)
	let feedNameView = RSSingleLineView(frame: NSZeroRect)

	var cellAppearance: TimelineCellAppearance!
	var cellData: TimelineCellData! {
		didSet {
			updateSubviews()
		}
	}
	
	override var isFlipped: Bool {
		return true
	}
	
	var isEmphasized = false {
		didSet {
			dateView.emphasized = isEmphasized
			feedNameView.emphasized = isEmphasized
			titleView.emphasized = isEmphasized	
		}
	}
	
	var isSelected = false {
		didSet {
			dateView.selected = isSelected
			feedNameView.selected = isSelected
			titleView.selected = isSelected
		}
	}
	
	private func commonInit() {
		
		addSubview(titleView)
		titleView.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(unreadIndicatorView)
		unreadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		unreadIndicatorView.isHidden = true
		
		addSubview(dateView)
		dateView.translatesAutoresizingMaskIntoConstraints = false

		addSubview(feedNameView)
		feedNameView.translatesAutoresizingMaskIntoConstraints = false;
		feedNameView.isHidden = true
	}
	
	override init(frame frameRect: NSRect) {
		
		super.init(frame: frameRect)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
		commonInit()
	}
	
	override func setFrameSize(_ newSize: NSSize) {
		
		if newSize == self.frame.size {
			return
		}
		
		super.setFrameSize(newSize)
		updateSubviews()
		needsLayout = true
	}

	override func viewDidMoveToSuperview() {
		
		updateSubviews()
		updateAppearance()
	}
	
	private func updatedLayoutRects() -> TimelineCellLayout {

		return timelineCellLayout(NSWidth(bounds), cellData: cellData, appearance: cellAppearance)
	}

	override func layout() {

		resizeSubviews(withOldSize: NSZeroSize)
	}
	
	override func resizeSubviews(withOldSize oldSize: NSSize) {
		
		let layoutRects = updatedLayoutRects()
		titleView.rs_setFrameIfNotEqual(layoutRects.titleRect)
		unreadIndicatorView.rs_setFrameIfNotEqual(layoutRects.unreadIndicatorRect)
		dateView.rs_setFrameIfNotEqual(layoutRects.dateRect)
		feedNameView.rs_setFrameIfNotEqual(layoutRects.feedNameRect)
	}
	
	private func updateTitleView() {

		titleView.attributedStringValue = cellData.attributedTitle
		needsLayout = true
	}
	
	private func updateDateView() {

		dateView.attributedStringValue = cellData.attributedDateString
		needsLayout = true
	}

	private func updateFeedNameView() {

		if cellData.showFeedName {
			if feedNameView.isHidden {
				feedNameView.isHidden = false
			}
			feedNameView.attributedStringValue = cellData.attributedFeedName
		}
		else {
			if !feedNameView.isHidden {
				feedNameView.isHidden = true
			}
		}
	}

	private func updateUnreadIndicator() {
		
		if unreadIndicatorView.isHidden != cellData.read {
			unreadIndicatorView.isHidden = cellData.read
		}
	}

	private func updateSubviews() {

		updateTitleView()
		updateDateView()
		updateFeedNameView()
		updateUnreadIndicator()
	}
	
	private func updateAppearance() {
		
		if let rowView = superview as? NSTableRowView {
			isEmphasized = rowView.isEmphasized
			isSelected = rowView.isSelected
		}
		else {
			isEmphasized = false
			isSelected = false
		}
	}
}
