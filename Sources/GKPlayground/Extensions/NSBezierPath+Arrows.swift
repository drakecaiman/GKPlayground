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
//TODO: Separate from `NodeMapView` depedency
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

//  TODO: Add start-point arrowhead
//  if connections[nextExitState]?.contains(nextStateName) ?? false
//  {
//  arrowPath.move(to: nextArrowStart)
//  arrowPath.relativeLine(to: CGPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
//  y: arrowheadLength * sin(CGFloat.pi / 4)))
//  arrowPath.move(to: nextArrowStart)
//  arrowPath.relativeLine(to: CGPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
//  y: -arrowheadLength * sin(CGFloat.pi / 4)))
//
//  //                      Remove state
//  connections[nextExitState]?.remove(nextStateName)
//  }
}
