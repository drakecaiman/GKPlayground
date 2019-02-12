//
//  GKStateMachine+ CustomPlaygroundDisplayConvertible .swift
//  GKPlayground
//
//  Created by Duncan on 2/6/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import GameplayKit


extension String
{
    public func cgGlyphs(forFont font: NSFont) -> [CGGlyph]
    {
        var glyphs = [CGGlyph]()
        
        for c in self
        {
            let nextGlyph = font.glyph(withName: String(c))
            glyphs.append(CGGlyph(nextGlyph))
        }
        
        return glyphs
    }
}

extension GKState// : CustomPlaygroundDisplayConvertible
{
    public var playgroundDescription : Any
    {
        let stateRect = NSRect(origin: CGPoint.zero, size: NodeView.defaultNodeSize)
        let stateNodeView = NodeView(frame: stateRect)
        stateNodeView.name = String(describing: type(of: self))
        
        return stateNodeView
    }
    
    // TODO: move 'playgroundDescription' here?
    public var stateView : NSView
    {
        return NSView()
    }
}

extension GKStateMachine// : CustomPlaygroundDisplayConvertible
{
    public var playgroundDescription: Any
    {
        return NSView()
    }
}

extension Array : CustomPlaygroundDisplayConvertible where Element == GKState
{
    public var playgroundDescription : Any
    {
//      Get connections between states
        var connections = [String : Set<String>]()
        for currentState in self
        {
            let currentStateName = String(describing: type(of: currentState))
            for outState in self
            {
                guard currentState.isValidNextState(type(of: outState)) else { continue }
                let outStateName = String(describing: type(of: outState))
                if connections[currentStateName] == nil
                {
                    connections[currentStateName] = Set<String>()
                }
                connections[currentStateName]?.insert(outStateName)
            }
        }
        
//      Get views
        let viewRect = NSRect(x: 0, y: 0, width: 200, height: 200)
        let view = NodeMapView(frame: viewRect)
        
        let nodeSpacing : CGFloat = 25.0
        var nodeOrigin = CGPoint(x: 0.0,
                                 y: view.frame.height - NodeView.defaultNodeSize.height)
        let arrowheadLength : CGFloat = 8.0
        
        for nextState in self
        {
            let nextStateName = String(describing: type(of: nextState))
            let nextViewFrame = NSRect(origin: nodeOrigin, size: NodeView.defaultNodeSize)
            let nextView = NodeView(frame: nextViewFrame)
            nextView.name = nextStateName
            
            view.addSubview(nextView)
            nodeOrigin.x = nextViewFrame.maxX + nodeSpacing
            nodeOrigin.y = nextViewFrame.minY - NodeView.defaultNodeSize.height
            
            if false
            {
//          Draw arrows
            if var nextStateTransistions = connections[nextStateName]
            {
                let nextPath = NSBezierPath()
                if nextStateTransistions.contains(nextStateName)
                {
//                    let selfArrowStart  = CGPoint(x: nextPath.bounds.minX, y: nextPath.bounds.midY)
//                    let selfArrowCenter = CGPoint(x: nextPath.bounds.minX, y: nextPath.bounds.maxY)
//                    let selfArrowEnd    = CGPoint(x: nextPath.bounds.minX + nextPath.bounds.midY,
//                                                  y: nextPath.bounds.maxY)
                    let selfArrowCenter = CGPoint(x: nextPath.bounds.minX, y: nextPath.bounds.maxY)
                    let arrowPath = NSBezierPath()
                    arrowPath.appendArc(withCenter: selfArrowCenter,
                                        radius: (nextPath.bounds.maxY - nextPath.bounds.midY),
                                        startAngle: 270.0,
                                        endAngle: 0,
                                        clockwise: true)
                    let arrowEnd = arrowPath.currentPoint
                    arrowPath.relativeLine(to: NSPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
                                                       y: arrowheadLength * sin(CGFloat.pi / 4)))
                    arrowPath.move(to: arrowEnd)
                    arrowPath.relativeLine(to: NSPoint(x: -arrowheadLength * cos(CGFloat.pi / 4),
                                                       y: arrowheadLength * sin(CGFloat.pi / 4)))
                    
                    nextStateTransistions.remove(nextStateName)
                }
                for nextExitState in nextStateTransistions
                {
                    let nextArrowStart = CGPoint(x: nextPath.bounds.maxX,
                                                 y: nextPath.bounds.midY)
                    let arrowPath = NSBezierPath()
                    arrowPath.move(to: nextArrowStart)
                    arrowPath.relativeLine(to: CGPoint(x: nodeSpacing,
                                                       y: 0.0))
                    let arrowEnd = arrowPath.currentPoint
                    arrowPath.relativeLine(to: NSPoint(x: -arrowheadLength * cos(CGFloat.pi / 4),
                                                       y: arrowheadLength * sin(CGFloat.pi / 4)))
                    arrowPath.move(to: arrowEnd)
                    arrowPath.relativeLine(to: NSPoint(x: -arrowheadLength * cos(CGFloat.pi / 4),
                                                       y: -arrowheadLength * sin(CGFloat.pi / 4)))
                    if connections[nextExitState]?.contains(nextStateName) ?? false
                    {
                        arrowPath.move(to: nextArrowStart)
                        arrowPath.relativeLine(to: NSPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
                                                           y: arrowheadLength * sin(CGFloat.pi / 4)))
                        arrowPath.move(to: nextArrowStart)
                        arrowPath.relativeLine(to: NSPoint(x: arrowheadLength * cos(CGFloat.pi / 4),
                                                           y: -arrowheadLength * sin(CGFloat.pi / 4)))
                        
//                      Remove state
                        connections[nextExitState]?.remove(nextStateName)
                    }
                }
                if nextStateTransistions.count > 0
                {
                    
                }
            }
            }
        }
        
        return view
    }
}
