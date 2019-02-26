//
//  NodeMapView.swift
//  GKPlayground
//
//  Created by Duncan on 2/11/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

class NodeMapView : NSView
{
    // MARK: Constants
    static let arrowheadLength      : CGFloat = 5.5
    static let arrowClearance       : CGFloat = 12.0
    
    // MARK: -
    public var margins = NSEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    public var connectionLineWidth  : CGFloat = 2.0
    public var connectionColor      : NSColor = .gray
    
    // MARK: - NSView properties
    override var isFlipped: Bool { return true }
    
    // MARK: -
    func refresh()
    {
        self.resizeToFitNodeViews()
        self.redrawArrows()
    }
    
    // MARK: -
    private func layoutNodes()
    {
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
    
    private func redrawArrows()
    {
        self.needsDisplay = true
    }
    
    private func resizeToFitNodeViews()
    {
        let furthestXView = self.subviews.max { $0.frame.maxX < $1.frame.maxX }
        let furthestYView = self.subviews.max { $0.frame.maxY < $1.frame.maxY }
        guard   let maxX = furthestXView?.frame.maxX,
                let maxY = furthestYView?.frame.maxY
            else { return }
        
        let newFrameRect = NSRect(x:        0.0,
                                  y:        0.0,
                                  width:    maxX
                                            + self.margins.left
                                            + self.margins.right,
                                  height:   maxY
                                            + self.margins.top
                                            + self.margins.bottom)
        self.frame = newFrameRect
    }
    
    private func drawConnections()
    {
        for subview in self.subviews
        {
            guard let nodeView = subview as? NodeView else { continue }
            self.drawConnections(forNodeView: nodeView)
        }
    }
    
    private func drawConnections(forNodeView nodeView: NodeView)
    {
        for nextConnection in nodeView.outConnections
        {
            let nextArrow : NSBezierPath
            if (nextConnection == nodeView)
            {
                nextArrow = self.arrow(from: nodeView, to: nodeView, clearing: .over)
            }
            else
            {
                let clearing : ArrowClearingBehavior =
                    nodeView.frame.origin.x <= nextConnection.frame.origin.x ?
                        .out : .under
                nextArrow = self.arrow(from: nodeView, to: nextConnection, clearing: clearing)
            }
            self.connectionColor.setStroke()
            nextArrow.stroke()
        }
    }
    
    private func newArrowPath() -> NSBezierPath
    {
        let path = NSBezierPath()
        path.lineWidth = self.connectionLineWidth
        
        return path
    }
    
    enum ArrowClearingBehavior
    {
        case out
        case over
        case under
    }
    // TODO: Make optional? (I: 🔅)
    private func arrow(from fromView: NodeView, to toView: NodeView, clearing: ArrowClearingBehavior = .out) -> NSBezierPath
    {
        let arrowPath = self.newArrowPath()
        guard fromView.isDescendant(of: self),
                toView.isDescendant(of: self)
            else { return arrowPath }
        guard let nextArrowStart  = fromView.outPoint(forView: toView) else { return arrowPath }
        guard let nextArrowEnd    = toView.inPoint(forView: fromView) else { return arrowPath }
        
        let clearedOutPoint : NSPoint
        let clearedInPoint  : NSPoint
        switch clearing
        {
        case .out:
            let lateralDistance = max(abs(nextArrowEnd.x - nextArrowStart.x),
                                      NodeMapView.arrowClearance)
            clearedOutPoint = NSPoint(x: nextArrowStart.x + lateralDistance,
                                      y: nextArrowStart.y)
            clearedInPoint = NSPoint(x: nextArrowEnd.x - lateralDistance,
                                     y: nextArrowEnd.y)
        case .over:
            let distanceFromTopOut = nextArrowStart.y - fromView.frame.minY
            clearedOutPoint = NSPoint(x: nextArrowStart.x + fromView.frame.width,
                                      y: nextArrowStart.y - 3.25 * distanceFromTopOut)
            let distanceFromTopIn = nextArrowEnd.y - toView.frame.minY
            clearedInPoint = NSPoint(x: nextArrowEnd.x - toView.frame.width,
                                     y: nextArrowEnd.y - 3.25 * distanceFromTopIn)
        case .under:
            let distanceFromBottomOut = fromView.frame.maxY - nextArrowStart.y
            clearedOutPoint = NSPoint(x: nextArrowStart.x + fromView.frame.width,
                                      y: nextArrowStart.y + 3.25 * distanceFromBottomOut)
            let distanceFromBottomIn = toView.frame.maxY - nextArrowEnd.y
            clearedInPoint = NSPoint(x: nextArrowEnd.x - toView.frame.width,
                                     y: nextArrowEnd.y + 3.25 * distanceFromBottomIn)
        }
        arrowPath.move(to: nextArrowStart)
        arrowPath.curve(to: nextArrowEnd,
                        controlPoint1: clearedOutPoint,
                        controlPoint2: clearedInPoint)

        arrowPath.addArrowhead()
        
//        if connections[nextExitState]?.contains(nextStateName) ?? false
//        {
//            arrowPath.move(to: nextArrowStart)
//            arrowPath.relativeLine(to: NSPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
//                                               y: arrowheadLength * sin(CGFloat.pi / 4)))
//            arrowPath.move(to: nextArrowStart)
//            arrowPath.relativeLine(to: NSPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
//                                               y: -arrowheadLength * sin(CGFloat.pi / 4)))
//
//            //                      Remove state
//            connections[nextExitState]?.remove(nextStateName)
//        }
        
        return arrowPath
    }
    
    // MARK: - NSView methods
    override func draw(_ dirtyRect: NSRect)
    {
        self.drawConnections()
    }
    
    override func didAddSubview(_ subview: NSView)
    {
        self.refresh()
    }
    
    override func willRemoveSubview(_ subview: NSView)
    {
        self.refresh()
    }
}
