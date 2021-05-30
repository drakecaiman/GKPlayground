//
//  NSBezierPath+Arrows.swift
//  GKPlayground
//
//  Created by Duncan Oliver on 2/22/21.
//

import Foundation

extension CGMutablePath
{
  // MARK: Constants
  /// The length of each line segment used to draw the arrowhead of a connection line.
  public static let arrowheadLength   : CGFloat = 5.5

  /**
   Adds a right-facing arrowhead to the given `NSBezierPath` at the current point.
   */
//TODO: Separate from `NodeMapView` depedency
  func addArrowhead()
  {
    guard !self.isEmpty else { return }
    let arrowEnd = self.currentPoint
    let topArrowStart = arrowEnd + CGPoint(x: -CGMutablePath.arrowheadLength * cos(CGFloat.pi / 4),
                                           y: -CGMutablePath.arrowheadLength * sin(CGFloat.pi / 4))
    let bottomArrowStart = arrowEnd + CGPoint(x: -CGMutablePath.arrowheadLength * cos(CGFloat.pi / 4),
                                              y: CGMutablePath.arrowheadLength * sin(CGFloat.pi / 4))
//  TODO: Flip with transform
    self.addLines(between: [topArrowStart, arrowEnd], transform: .identity)
    self.addLines(between: [bottomArrowStart, arrowEnd], transform: .identity)
  }

  func addDot()
  {
    var dotFrame = CGRect(origin: .zero, size: CGSize.init(width: 2.0, height: 2.0))
    dotFrame.center = self.currentPoint
    self.addEllipse(in: dotFrame)
  }

//TODO: Add start-point arrowhead
}
