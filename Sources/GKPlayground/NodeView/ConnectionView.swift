//
//  ConnectionView.swift
//  
//
//  Created by Duncan Oliver on 3/6/21.
//

import SwiftUI

enum ConnectionPathError : Error
{
  case inNodeNotFound
  case inPortNotFound
  case outPortNotFound
}

struct ConnectionView : View, Identifiable
{
  // MARK: Constants
  /// The minimum distance for a connection line to travel out from a node before curving.
  public static let arrowClearance  : CGFloat = 12.0
  /// The width to use when drawing connections between nodes.
  public var connectionLineWidth    : CGFloat = 2.7
  /// The color of node connection lines.
//  TODO: Make color universal
//  public var connectionColor        : NSColor = #colorLiteral(red: 0.8694332242, green: 0.8694332242, blue: 0.8694332242, alpha: 1)

  var id : String { self.connectionBody.connection.id }

  @Binding var bodyMap : BodyMap
  @Binding var connectionBody : ConnectionBody

  var body : some View
  {
    if let path = self.path
    {
    Path(path)
      .stroke(lineWidth: self.connectionLineWidth)
//    TODO: Make color universal
//      .foregroundColor(self.connectionColor)
      .fill()
    }
    else
    {
      EmptyView()
    }
  }

//TODO: out, over, under
  private var path : CGPath?
  {
//  TODO: Add errors
    guard let inPortBody = bodyMap.idBodyDictionary[self.connectionBody.connection.inID] as? PortBody,
          let outPortBody = bodyMap.idBodyDictionary[self.connectionBody.connection.outID] as? PortBody
          else { return nil }
    let inControl = CGPoint(x: outPortBody.frame.center.x, y: inPortBody.frame.center.y)
    let outControl = CGPoint(x: inPortBody.frame.center.x, y: outPortBody.frame.center.y)
    let inClearancePoint = (try? self.getClearancePoint(forPortBody: inPortBody)) ?? inPortBody.frame.center
    let outClearancePoint = (try? self.getClearancePoint(forPortBody: outPortBody)) ?? outPortBody.frame.center
    let path = CGMutablePath()
    path.move(to: inPortBody.frame.center)
    path.addDot()
    path.addLine(to: inClearancePoint)
    path.addCurve(to: outClearancePoint, control1: inControl, control2: outControl)
    path.addLine(to: outPortBody.frame.center)
    path.addDot()

    return path
  }

//TODO: Add fallback for clearance in direction of out port
  private func getClearancePoint(forPortBody portBody: PortBody) throws -> CGPoint
  {
    guard let nodeBody = try? bodyMap.body(forID: portBody.port.parentID) as? NodeBody
      else { throw ConnectionPathError.inNodeNotFound }
      let inEdge = nodeBody.frame.preferredEdge(forPoint: portBody.frame.origin)
      var length = ConnectionView.arrowClearance
      if inEdge.isMin { length.negate() }
      return portBody.frame.center + (inEdge.isX ? CGPoint(x: length, y: 0.0) : CGPoint(x: 0.0, y: length))
  }
}

// !!!: Logic for drawing connections in different directions
///**
// Creates a new `NSBezierPath` for an arrow pointing from one `NodeView` to another.
//
// - Parameter fromView:  The `NodeView` the resulting arrow is pointing away from.
// - Parameter toView:    The `NodeView` the resulting arrow is pointing towards.
// - Parameter clearing:  A `ArrowClearingBehavior` value describing  the direction the arrow
//                        should travel
//
// - Returns: A `NSBezierPath` representing the desired arrow.
// */
//private func arrow(from fromView: NodeView,
//           to toView: NodeView,
//           clearing: ArrowClearingBehavior = .out)
//  -> NSBezierPath
//{
//  let arrowPath = self.newArrowPath()
//  guard   fromView.isDescendant(of: self),
//    toView.isDescendant(of: self),
//    let nextArrowStart  = fromView.outPoint(forView: toView),
//    let nextArrowEnd    = toView.inPoint(forView: fromView)
//    else { return arrowPath }
//
//  let clearedOutPoint: CGPoint
//  let clearedInPoint: CGPoint
//  switch clearing
//  {
//  case .out:
//    let lateralDistance = max(abs(nextArrowEnd.x - nextArrowStart.x),
//                  NodeMapView.arrowClearance)
//    clearedOutPoint = CGPoint(x: nextArrowStart.x + lateralDistance, y: nextArrowStart.y)
//    clearedInPoint  = CGPoint(x: nextArrowEnd.x - lateralDistance, y: nextArrowEnd.y)
//  case .over:
////    TODO: Factor out constant
//    let distanceFromTopOut = nextArrowStart.y - fromView.frame.minY
//    clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
//                  y: nextArrowStart.y - 3.25 * distanceFromTopOut)
//    let distanceFromTopIn = nextArrowEnd.y - toView.frame.minY
//    clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
//                 y: nextArrowEnd.y - 3.25 * distanceFromTopIn)
//  case .under:
//    let distanceFromBottomOut = fromView.frame.maxY - nextArrowStart.y
//    clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
//                  y: nextArrowStart.y + 3.25 * distanceFromBottomOut)
//    let distanceFromBottomIn = toView.frame.maxY - nextArrowEnd.y
//    clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
//                 y: nextArrowEnd.y + 3.25 * distanceFromBottomIn)
//  }
//  arrowPath.move(to: nextArrowStart)
//  arrowPath.curve(to: nextArrowEnd,
//          controlPoint1: clearedOutPoint,
//          controlPoint2: clearedInPoint)
//
//  arrowPath.addArrowhead()
//
//  return arrowPath
//}
