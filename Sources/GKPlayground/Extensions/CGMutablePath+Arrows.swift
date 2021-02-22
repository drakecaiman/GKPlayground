//
//  NSBezierPath+Arrows.swift
//  GKPlayground
//
//  Created by Duncan Oliver on 2/22/21.
//

import Foundation

extension CGMutablePath
{
  /**
   Adds a right-facing arrowhead to the given `NSBezierPath` at the current point.
   */
//TODO: Separate from `NodeMapView` depedency
  func addArrowhead()
  {
    guard !self.isEmpty else { return }
    let arrowEnd = self.currentPoint
    let topArrowStart = arrowEnd + CGPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
                                y: -NodeMapView.arrowheadLength * sin(CGFloat.pi / 4))
    let bottomArrowStart = arrowEnd + CGPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
                                   y: NodeMapView.arrowheadLength * sin(CGFloat.pi / 4))
//  TODO: Flip with transform
    self.addLines(between: [topArrowStart, arrowEnd], transform: .identity)
    self.addLines(between: [bottomArrowStart, arrowEnd], transform: .identity)
  }

//TODO: Add start-point arrowhead
}
