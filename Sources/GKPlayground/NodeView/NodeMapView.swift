//
//  NodeMapView.swift
//  GKPlayground
//
//  Created by Duncan on 2/11/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Cocoa

open class NodeMapView: NSView
{
	// MARK: Constants
	/// The length of each line segment used to draw the arrowhead of a connection line.
	public static let arrowheadLength   : CGFloat = 5.5
	/// The minimum distance for a connection line to travel out from a node before curving.
	public static let arrowClearance	: CGFloat = 12.0
	
	// MARK: -
	/// The distance on each side between the content of this view and its edges
	open var margins = NSEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
	/// The width to use when drawing connections between nodes.
	open var connectionLineWidth    : CGFloat = 2.7
	/// The color of node connection lines.
	open var connectionColor        : NSColor = #colorLiteral(red: 0.8694332242, green: 0.8694332242, blue: 0.8694332242, alpha: 1)
	
	// MARK: - NSView properties
	// TODO: Add check for isFlipped to drawing now that open? (I: 🔅)
	override open var isFlipped: Bool { return true }
	
	// MARK: -
	/**
	 Update this view based on changes its subviews.
	 */
	public func refresh()
	{
		self.resizeToFitNodeViews()
		self.redrawArrows()
	}
	
	// MARK: -
	/**
	 Position the contained `NodeView` instances for readability.
	 */
	private func layoutNodes()
	{
//  TODO: Layout (Things)
		//        var layoutGrid = [Int : (Int, Int)]()
		//        var nextPosition = (0,0)
		//        var nodeOrigin = CGPoint(x: NodeMapView.margin.width + NodeMapView.arrowClearance,
		//                                 y: self.frame.height -
		//                                    NodeMapView.margin.height -
		//                                    NodeMapView.arrowClearance -
		//                                    NodeView.minNodeSize.height)
		
		//        for (index, subview) in self.subviews.enumerated()
		//        {
		//            guard   !layoutGrid.keys.contains(index),
		//                    let nodeView = subview as? NodeView else { continue }
		//            layoutGrid[index] = nextPosition
		//            for nextConnection in nodeView.outConnections
		//            {
		//
		//            }
		//        }
		
		//        let nodeSpacing : CGFloat = 25.0
		//        nodeOrigin.x = nextViewFrame.maxX + nodeSpacing
		//        nodeOrigin.y = nextViewFrame.minY - NodeView.minNodeSize.height
	}
	
	/**
	 Redraw the connection arrow for this `NodeMapView` instance's nodes.
	 */
	private func redrawArrows()
	{
		self.needsDisplay = true
	}
	
	/**
	 Resizes this view to tightly contain its children `NodeView` instances with the margins
	 specified in `margins`.
	 */
	private func resizeToFitNodeViews()
	{
		let furthestXView = self.subviews.max { $0.frame.maxX < $1.frame.maxX }
		let furthestYView = self.subviews.max { $0.frame.maxY < $1.frame.maxY }
		guard   let maxX = furthestXView?.frame.maxX,
			let maxY = furthestYView?.frame.maxY
			else { return }
		
		let newFrameRect = CGRect(x:  0.0,
                              y:  0.0,
                              width:  maxX + self.margins.left + self.margins.right,
								  height:   maxY + self.margins.top + self.margins.bottom)
		self.frame = newFrameRect
	}

  /**
   Clear all connection sublayers in view.
   */
  private func clearConnections()
  {
    guard let sublayers = (self.layer?.sublayers?.filter { $0.name == "connection" }) else { return }
    for nextLayer in sublayers
    {
      nextLayer.removeFromSuperlayer()
    }
  }
	
	/**
	 Draw all connections for each `NodeView` in this view.
	 */
	private func drawConnections()
	{
		for case let nodeView as NodeView in self.subviews
		{
			self.drawConnections(forNodeView: nodeView)
		}
	}
	
	/**
	 Draw all outward connections for the given `NodeView`.
	
	 - Parameter nodeView: The `NodeView` from which connections will be drawn.
	 */
	private func drawConnections(forNodeView nodeView: NodeView)
	{
		for nextConnection in nodeView.outConnections
		{
      let nextArrow : CGPath
			if (nextConnection == nodeView)
			{
				nextArrow = self.arrow(from: nodeView, to: nodeView, clearing: .over)
			}
			else
			{
				let clearing: ArrowClearingBehavior =
					nodeView.frame.origin.x <= nextConnection.frame.origin.x ? .out : .under
				nextArrow = self.arrow(from: nodeView, to: nextConnection, clearing: clearing)
			}

      let layer = CAShapeLayer()
      layer.path = nextArrow
      layer.name = "connection"
      layer.fillColor = .clear
      layer.strokeColor = connectionColor.cgColor
      layer.lineCap = .square
      layer.lineWidth = connectionLineWidth
      self.layer?.addSublayer(layer)
		}
	}
	
	/**
	 Create a new `NSBezierPath` for drawing node connections.
	
	 - Returns: A new arrow `NSBezierPath`
	 */
	private func newArrowPath() -> NSBezierPath
	{
		let path = NSBezierPath()
    path.lineCapStyle = .square
		path.lineWidth = self.connectionLineWidth
		
		return path
	}
	
	/**
	 `ArrowClearingBehavior` describes the different approaches for drawing an arrow leaving a node.
	 */
	enum ArrowClearingBehavior
	{
		/// The arrow points straight and away from the node.
		case out
		/// The arrow travels above the node.
		case over
		/// The arrow travels below the node.
		case under
	}
//TODO: Make optional? (I: 🔅)
//TODO: Consolidate with `NSBezierPath` method
  /**
   Creates a new `CGPath` for an arrow pointing from one `NodeView` to another.

   - Parameter fromView:  The `NodeView` the resulting arrow is pointing away from.
   - Parameter toView:    The `NodeView` the resulting arrow is pointing towards.
   - Parameter clearing:  A `ArrowClearingBehavior` value describing  the direction the arrow
                          should travel

   - Returns: A `CGPath` representing the desired arrow.
   */
  private func arrow(from fromView: NodeView,
                     to   toView: NodeView,
                          clearing: ArrowClearingBehavior = .out)
    -> CGPath
  {
    let arrowPath = CGMutablePath()
    guard   fromView.isDescendant(of: self),
            toView.isDescendant(of: self),
            let nextArrowStart  = fromView.outPoint(forView: toView),
            let nextArrowEnd    = toView.inPoint(forView: fromView)
            else { return arrowPath }

    let clearedOutPoint: CGPoint
    let clearedInPoint: CGPoint
    switch clearing
    {
    case .out:
      let lateralDistance = max(abs(nextArrowEnd.x - nextArrowStart.x),
                    NodeMapView.arrowClearance)
      clearedOutPoint = CGPoint(x: nextArrowStart.x + lateralDistance, y: nextArrowStart.y)
      clearedInPoint  = CGPoint(x: nextArrowEnd.x - lateralDistance, y: nextArrowEnd.y)
    case .over:
//    TODO: Factor out constant
      let distanceFromTopOut = nextArrowStart.y - fromView.frame.minY
      clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
                    y: nextArrowStart.y - 3.25 * distanceFromTopOut)
      let distanceFromTopIn = nextArrowEnd.y - toView.frame.minY
      clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
                   y: nextArrowEnd.y - 3.25 * distanceFromTopIn)
    case .under:
      let distanceFromBottomOut = fromView.frame.maxY - nextArrowStart.y
      clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
                    y: nextArrowStart.y + 3.25 * distanceFromBottomOut)
      let distanceFromBottomIn = toView.frame.maxY - nextArrowEnd.y
      clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
                   y: nextArrowEnd.y + 3.25 * distanceFromBottomIn)
    }
    arrowPath.move(to: nextArrowStart)
    arrowPath.addCurve(to: nextArrowEnd, control1: clearedOutPoint, control2: clearedInPoint)

    arrowPath.addArrowhead()

    return arrowPath
  }

	/**
	 Creates a new `NSBezierPath` for an arrow pointing from one `NodeView` to another.
	
	 - Parameter fromView:  The `NodeView` the resulting arrow is pointing away from.
	 - Parameter toView:    The `NodeView` the resulting arrow is pointing towards.
	 - Parameter clearing:  A `ArrowClearingBehavior` value describing  the direction the arrow
                          should travel
	
	 - Returns: A `NSBezierPath` representing the desired arrow.
	 */
	private func arrow(from fromView: NodeView,
					   to toView: NodeView,
					   clearing: ArrowClearingBehavior = .out)
		-> NSBezierPath
	{
		let arrowPath = self.newArrowPath()
		guard   fromView.isDescendant(of: self),
			toView.isDescendant(of: self),
			let nextArrowStart  = fromView.outPoint(forView: toView),
			let nextArrowEnd    = toView.inPoint(forView: fromView)
			else { return arrowPath }
		
		let clearedOutPoint: CGPoint
		let clearedInPoint: CGPoint
		switch clearing
		{
		case .out:
			let lateralDistance = max(abs(nextArrowEnd.x - nextArrowStart.x),
									  NodeMapView.arrowClearance)
			clearedOutPoint = CGPoint(x: nextArrowStart.x + lateralDistance, y: nextArrowStart.y)
			clearedInPoint  = CGPoint(x: nextArrowEnd.x - lateralDistance, y: nextArrowEnd.y)
		case .over:
//    TODO: Factor out constant
			let distanceFromTopOut = nextArrowStart.y - fromView.frame.minY
			clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
									  y: nextArrowStart.y - 3.25 * distanceFromTopOut)
			let distanceFromTopIn = nextArrowEnd.y - toView.frame.minY
			clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
									 y: nextArrowEnd.y - 3.25 * distanceFromTopIn)
		case .under:
			let distanceFromBottomOut = fromView.frame.maxY - nextArrowStart.y
			clearedOutPoint = CGPoint(x: nextArrowStart.x + fromView.frame.width,
									  y: nextArrowStart.y + 3.25 * distanceFromBottomOut)
			let distanceFromBottomIn = toView.frame.maxY - nextArrowEnd.y
			clearedInPoint = CGPoint(x: nextArrowEnd.x - toView.frame.width,
									 y: nextArrowEnd.y + 3.25 * distanceFromBottomIn)
		}
		arrowPath.move(to: nextArrowStart)
		arrowPath.curve(to: nextArrowEnd,
						controlPoint1: clearedOutPoint,
						controlPoint2: clearedInPoint)
		
		arrowPath.addArrowhead()
		
		return arrowPath
	}
	
	// MARK: - NSView methods
	override open func draw(_ dirtyRect: NSRect)
	{
    self.clearConnections()
		self.drawConnections()
	}
	
	override open func didAddSubview(_ subview: NSView)
	{
		self.refresh()
	}
	
	override open func willRemoveSubview(_ subview: NSView)
	{
		self.refresh()
	}
}
