//
//  NodeView.swift
//  GKPlayground
//
//  Created by Duncan on 2/10/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

class NodeView : NSView
{
    static let minNodeSize = CGSize(width: 100.0, height: 32.0)
    static let maxNodeSize = CGSize(width: 200.0,  height: 178.0)
    
    let nodePadding             : CGFloat = 8.0
    let nodeConnectionClearance : CGFloat = 16.0
    let nodeBorderWidth         : CGFloat = 1.0
    
    public var name         : String?
    {
        didSet
        {
            self.resizeNode()
        }
    }
    public var nodeColor    : NSColor = #colorLiteral(red: 0.1160337528, green: 0.8740647007, blue: 0.940814124, alpha: 1)
    public var textColor    : NSColor = .white
    
    public var nodeMapView : NodeMapView? { return self.superview as? NodeMapView }
    // TODO: Make weak collections
    public var inConnections    = [NodeView]()
    {
        didSet
        {
            self.sortConnections(in: &self.inConnections)
            self.resizeNode()
        }
    }
    public var outConnections   = [NodeView]()
    {
        didSet
        {
            self.sortConnections(in: &self.outConnections)
            self.resizeNode()
        }
    }
    
    private var dragStart   : NSPoint?
    private var dragOffset  : NSPoint?
    
    private var nameParagraphStyle : NSParagraphStyle
    {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }
    private var nodeNameStringAttributes : [NSAttributedString.Key : Any]
    {
        return [.font               : NSFont.boldSystemFont(ofSize: 12.0),
                .foregroundColor    : self.textColor,
                .paragraphStyle     : self.nameParagraphStyle]
    }

//    convenience init(withName initialName: String)
//    {
//        self.init(frame: NodeView.minNodeSize)
//    }
    
    // MARK: -
    public func inPoint(forView view: NodeView) -> CGPoint?
    {
        guard let connectionY = self.connectionY(ofView: view, forConnectionArray: self.inConnections)
            else { return nil }
        return CGPoint(x: self.frame.minX,
                       y: connectionY)
    }
    
    public func outPoint(forView view: NodeView) -> CGPoint?
    {
        guard let connectionY = self.connectionY(ofView: view, forConnectionArray: self.outConnections)
            else { return nil }
        return CGPoint(x: self.frame.maxX,
                       y: connectionY)
    }
    
    private func sortConnections(in connections: inout [NodeView])
    {
        if let selfIndex = connections.firstIndex(of: self)
        {
            let selfConnection = connections.remove(at: selfIndex)
            connections.insert(selfConnection, at: 0)
        }
    }
    
    private func connectionY(ofView view: NodeView, forConnectionArray connectionArray: [NodeView]) -> CGFloat?
    {
        guard let viewIndex = connectionArray.firstIndex(of: view) else { return nil }
        return self.frame.minY
            + self.nodePadding
            + (self.nodeConnectionClearance * CGFloat(viewIndex))
    }
    
    private func repositionNode()
    {
        let newOrigin = CGPoint(x: max(self.frame.origin.x,
                                       (NodeMapView.arrowClearance + NodeMapView.margin.width)),
                                y: max(self.frame.origin.y,
                                       (NodeMapView.arrowClearance + NodeMapView.margin.height)))
        guard newOrigin != self.frame.origin else { return }
        let newRect = NSRect(origin: newOrigin, size: self.frame.size)
        
//      Make move animations
        let moveAnimations : [NSViewAnimation.Key : Any ] = [.startFrame:   self.frame,
                                                             .endFrame:     newRect,
                                                             .target:       self]
        let repositionAnimation = NSViewAnimation(viewAnimations: [moveAnimations])
        repositionAnimation.duration = 0.23
        repositionAnimation.delegate = self
        repositionAnimation.start()
        
        // TODO: if origin less than zero possible, refresh NodeMapView
    }
    
    private func resizeNode()
    {
//      Caluclate height based on the most number of connections on a side
        let maxConnectionPerSide = max(self.inConnections.count, self.outConnections.count)
        let nodeHeight  = 2.0 * (self.nodePadding + self.nodeBorderWidth)
            + (CGFloat(max(maxConnectionPerSide - 1, 0)) * self.nodeConnectionClearance)
//      Calculate width based on node name
        let maxStringRect = NSString(string: self.name ?? "")
                .boundingRect(with:         NSRect.infinite.size,
                              options:      [],
                              attributes:   self.nodeNameStringAttributes)
        let nodeWidth   = maxStringRect.insetBy(dx: -(self.nodePadding + self.nodeBorderWidth),
                                                dy: -(self.nodePadding + self.nodeBorderWidth)).size.width
        self.frame.size = NSSize(
            width:  nodeWidth.clamped(to: NodeView.minNodeSize.width...NodeView.maxNodeSize.width),
            height: nodeHeight.clamped(to: NodeView.minNodeSize.height...NodeView.maxNodeSize.height))
        self.nodeMapView?.refresh()
    }
    
    // MARK: NSView methods
    public override func draw(_ dirtyRect: NSRect)
    {
        //      Get node rect
        let stateNodeRect = NSRect(origin: .zero, size: self.frame.size)
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
            let nodeNameConstraintRect = stateNodeRect.insetBy(dx: nodePadding,
                                                               dy: nodePadding)
            let nodeNameBoundingRect = NSString(string: nodeDrawName)
                .boundingRect(with:         nodeNameConstraintRect.size,
                              options:      [],
                              attributes:   self.nodeNameStringAttributes)
            let rectDifference = nodeNameConstraintRect.height - nodeNameBoundingRect.height
            let nodeNameRect = nodeNameConstraintRect.insetBy(dx: 0.0,
                                                              dy: rectDifference / 2.0)
            NSString(string: nodeDrawName).draw(in: nodeNameRect,
                                                withAttributes: self.nodeNameStringAttributes)
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
        
        self.nodeMapView?.refresh()
    }
    
    public override func mouseUp(with event: NSEvent)
    {
        self.dragOffset = nil
        
        self.repositionNode()
    }
}

extension NodeView : NSAnimationDelegate
{
    func animation(_ animation: NSAnimation, valueForProgress progress: NSAnimation.Progress) -> Float
    {
        self.nodeMapView?.refresh()
        return progress
    }
}
