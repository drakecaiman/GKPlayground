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
//    static let
    static let margin               : CGSize  = CGSize(width: 12.0, height: 12.0)
    static let connectionLineWidth  : CGFloat = 2.0
    static let arrowheadLength      : CGFloat = 5.5
    static let arrowClearance      : CGFloat = 12.0
    static let connectionColor      : NSColor = .gray
    
    // MARK: NSView properties
    override var isFlipped: Bool { return true }
    
//    var connectionView : NSView
    
    // MARK: Initialization
//    override init(frame frameRect: NSRect)
//    {
//        self.connectionView = NSView(frame: frameRect)
//        self.connectionView.wantsLayer = true
//        super.init(frame: frameRect)
//    }
    
//    required init?(coder decoder: NSCoder)
//    {
//        fatalError()
        // TODO: Connection View initializations
//        super.init(coder: decoder)
//    }
    
    // MARK: -
    func refresh()
    {
        self.resizeToFitNodeViews()
        self.redrawArrows()
    }
    
    // TODO: Try to make private?
    func resizeToFitNodeViews()
    {
        let maxX = self.subviews.map { $0.frame.maxX }.max() ?? 0.0
        let maxY = self.subviews.map { $0.frame.maxY }.max() ?? 0.0
//        let minX = max(self.subviews.map { $0.frame.minX }.min() ?? 0.0, 0.0)
//        let minY = max(self.subviews.map { $0.frame.minY }.min() ?? 0.0, 0.0)
        
        
        let newFrameRect = NSRect(x:        0.0,
                                  y:        0.0,
                                  width:    maxX
                                    + 2 * (NodeMapView.arrowClearance + NodeMapView.margin.width),
                                  height:   maxY
                                    + 2 * (NodeMapView.arrowClearance + NodeMapView.margin.height))
        self.frame = newFrameRect
//        self.frame = newFrameRect.insetBy(dx: -NodeMapView.margin.width,
//                                          dy: -NodeMapView.margin.height)
    }
    
    func redrawArrows()
    {
        self.needsDisplay = true
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
            NodeMapView.connectionColor.setStroke()
            nextArrow.stroke()
        }
    }
    
    // TODO: Smart layout of nodes on creation based on connection
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
    
    private func newArrowPath() -> NSBezierPath
    {
        let path = NSBezierPath()
        path.lineWidth = NodeMapView.connectionLineWidth
        
        return path
    }
    
    private func selfArrow(forView nodeView: NodeView) -> NSBezierPath
    {
        let arrowPath = self.newArrowPath()
        guard nodeView.isDescendant(of: self) else { return arrowPath }
//      Draw arrow shaft
        let selfArrowCenter = CGPoint(x: nodeView.frame.minX,
                                      y: nodeView.frame.minY)
        arrowPath.appendArc(withCenter: selfArrowCenter,
                            radius:     nodeView.nodePadding,
                            startAngle: 0.0,
                            endAngle:   90.0,
                            clockwise:  true)
//      Draw arrowhead
        arrowPath.addArrowhead()
    
        return arrowPath
    }
    
    enum ArrowClearingBehavior
    {
        case out
        case over
        case under
    }
    // TODO: Make optional?
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
                                      fromView.nodeConnectionClearance)
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
    
    // MARK: NSView methods
    override func display()
    {
        print("Testing")
        self.resizeToFitNodeViews()
        super.display()
    }
    
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

extension NSBezierPath
{
    func addArrowhead()
    {
        guard !self.isEmpty else { return }
        let arrowEnd = self.currentPoint
        self.relativeLine(to: NSPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
                                      y: -NodeMapView.arrowheadLength * sin(CGFloat.pi / 4)))
        self.move(to: arrowEnd)
        self.relativeLine(to: NSPoint(x: -NodeMapView.arrowheadLength * cos(CGFloat.pi / 4),
                                      y: NodeMapView.arrowheadLength * sin(CGFloat.pi / 4)))
    }
}
