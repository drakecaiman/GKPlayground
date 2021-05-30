//
//  File.swift
//  
//
//  Created by Duncan Oliver on 5/9/21.
//

import Foundation

extension CGRect
{
  var center : CGPoint
  {
    get
    {
      CGPoint(x: self.midX, y: self.midY)
    }
    set
    {
      self.origin = newValue - (self.center - self.origin)
    }
  }
  public var min : CGPoint { CGPoint(x: self.minX, y: self.minY) }
  public var max : CGPoint { CGPoint(x: self.maxX, y: self.maxY) }

  static func union(_ rects: [CGRect]) -> CGRect
  {
    return rects.reduce(CGRect.null) { $0.union($1) }
  }

  static func union(_ rects: CGRect...) -> CGRect?
  {
    return self.union(rects)
  }


//TODO: Allow for multiple returns
  func preferredEdge(forPoint point: CGPoint) -> CGRectEdge
  {
    let distance = point - self.center
    let minDiagonal = self.min - self.center
    let maxDiagonal = self.max - self.center

    let bias : [CGRectEdge : CGFloat] =
      [
        .minXEdge: distance.x / minDiagonal.x,
        .minYEdge: distance.y / minDiagonal.y,
        .maxXEdge: distance.x / maxDiagonal.x,
        .maxYEdge: distance.y / maxDiagonal.y
      ]

    // `bias` will not be empty
    return bias.max { $0.value < $1.value }!.key
  }
}
