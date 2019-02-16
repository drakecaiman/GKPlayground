//
//  NodeView.swift
//  GKPlayground
//
//  Created by Duncan on 2/10/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

class NodeView : NSView, NSAnimationDelegate
{
    static let defaultNodeSize = CGSize(width: 100.0, height: 32.0)
    
    let nodePadding     : CGFloat   = 4.0
    let nodeBorderWidth : CGFloat   = 1.0
    
    public var name         : String?
    public var nodeColor    : NSColor = NSColor(fromInt: 0x2D7FC1)
    public var textColor    : NSColor = .white
    
    // TODO: Make weak collections
    public var inConnections    = [NodeView]()
    public var outConnections   = [NodeView]()
    
    private var dragStart   : NSPoint?
    private var dragOffset  : NSPoint?
    
    var nameParagraphStyle : NSParagraphStyle
    {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }

//    convenience init(withName initialName: String)
//    {
//        self.init(frame: NodeView.defaultNodeSize)
//        
//    }
    
    // MARK: -
    private func repositionNode()
    {
        
        let newOrigin = CGPoint(x: max(self.frame.origin.x,
                                       (NodeMapView.arrowClearance + NodeMapView.margin.width)),
                                y: max(self.frame.origin.y,
                                       (NodeMapView.arrowClearance + NodeMapView.margin.height)))
        guard newOrigin != self.frame.origin else { return }
        let newRect = NSRect(origin: newOrigin, size: self.frame.size)
//        self.run
        let moveAnimations : [NSViewAnimation.Key : Any ] = [.startFrame: self.frame,
                                                             .endFrame: newRect,
                                                             .target: self]
        let repositionAnimation = NSViewAnimation(viewAnimations: [moveAnimations])
        repositionAnimation.duration = 0.23
        repositionAnimation.delegate = self
        repositionAnimation.start()
    }
    
    // MARK: NSView methods
    public override func draw(_ dirtyRect: NSRect)
    {
        //      Get node rect
        let stateNodeRect = NSRect(origin: CGPoint.zero, size: self.frame.size)
            .insetBy(dx: nodeBorderWidth, dy: nodeBorderWidth)
        
        let stateNodePath = NSBezierPath(roundedRect: stateNodeRect,
                                         xRadius: nodePadding,
                                         yRadius: nodePadding)
        stateNodePath.lineWidth = nodeBorderWidth
        
        self.nodeColor.withAlphaComponent(0.35).setFill()
        stateNodePath.fill()
        self.nodeColor.setStroke()
        stateNodePath.stroke()
        // TODO: separate Pascal case name
        if let nodeDrawName = self.name
        {
            let nodeNameRect = stateNodeRect.insetBy(dx: nodePadding,
                                                     dy: nodePadding)
            let nodeNameAttributes : [NSAttributedString.Key : Any] =
                [.font              : NSFont.boldSystemFont(ofSize: 12.0),
                 .foregroundColor   : self.textColor,
                 .paragraphStyle    : self.nameParagraphStyle]
            NSString(string: nodeDrawName).draw(in: nodeNameRect,
                                                withAttributes: nodeNameAttributes)
        }
    }
    
    // MARK: NSResponder methods
    public override func mouseDown(with event: NSEvent)
    {
        guard let startingDragPosition = self.superview?.convert(event.locationInWindow, to: nil)
            else { return }
        // TODO: Delta instead of offset (+ vs -)
        self.dragOffset = startingDragPosition - self.frame.origin
    }
    
    public override func mouseDragged(with event: NSEvent)
    {
        guard   let dragOffset = self.dragOffset,
                let currentDragLocation = self.superview?.convert(event.locationInWindow, to: nil)
            else { return }
        self.frame.origin = currentDragLocation - dragOffset
        
        (self.superview as? NodeMapView)?.resizeToFitNodeViews()
        self.superview?.needsDisplay = true
    }
    
    public override func mouseUp(with event: NSEvent)
    {
        self.dragOffset = nil
        
        self.repositionNode()
    }
    
    // MARK: NSAnimationDelegate methods
    func animationDidEnd(_ animation: NSAnimation)
    {
        self.superview?.needsDisplay = true
    }
}

extension NSPoint
{
    static func +(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout NSPoint, rhs: NSPoint)
    {
        lhs = NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
