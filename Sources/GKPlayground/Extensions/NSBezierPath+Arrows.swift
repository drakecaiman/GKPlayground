//
//  NSBezierPath+Arrows.swift
//  GKPlayground
//
//  Created by Duncan on 2/26/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Cocoa

extension NSBezierPath
{
	/**
	 Adds a right-facing arrowhead to the given `NSBezierPath` at the current point.
	 */
	func addArrowhead()
	{
		guard !self.isEmpty else { return }
		let arrowEnd = self.currentPoint
		self.relativeLine(to: CGPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
									  y: -NodeMapView.arrowheadLength * sin(CGFloat.pi / 4)))
		self.move(to: arrowEnd)
		self.relativeLine(to: CGPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
									  y: NodeMapView.arrowheadLength * sin(CGFloat.pi / 4)))
	}
}
