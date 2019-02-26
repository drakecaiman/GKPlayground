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
    // MARK: Constants
    static let minSize = CGSize(width: 100.0, height: 32.0)
    static let maxSize = CGSize(width: 200.0,  height: 178.0)
    static let connectionSpacing : CGFloat = 16.0
    static let nodeConstraintLayoutManager = CAConstraintLayoutManager()

    // MARK: -
    // TODO: Store name in CATextLayer as NSAttributedString? (I: 🔅)
    public var name : String?
    {
        get
        {
            return self.nameLayer.string as? String
        }
        set
        {
            self.nameLayer.string = newValue
            self.resizeNode()
        }
    }
    public var nameAttributes : [NSAttributedString.Key : Any]
    {
        get
        {
            let currentFont = (self.nameLayer.font as? NSFont) ??
                NSFont.boldSystemFont(ofSize: self.nameLayer.fontSize)
            let font = NSFont(descriptor: currentFont.fontDescriptor, size: self.nameLayer.fontSize)
            return [.font               : font ?? currentFont,
                    .foregroundColor    : self.nameLayer.foregroundColor ?? NSColor.white.cgColor]
        }
        set
        {
            // TODO: Support other font classes (I: 🔆)
            if let newFont = newValue[.font] as? NSFont
            {
                self.nameLayer.font = newFont
            }
            if let newFontSize = (newValue[.font] as? NSFont)?.pointSize
            {
                self.nameLayer.fontSize = newFontSize
            }
            // TODO: Test for no `.foregroundColor` key (I: 🔆)
            let newColor = (newValue[.foregroundColor] as! CGColor)
            self.nameLayer.foregroundColor = newColor
        }
    }
    public var padding = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    // TODO: Make weak collections (I: 🔆)
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
    public var nodeMapView : NodeMapView? { return self.superview as? NodeMapView }
    
    // MARK: -
    private var nameLayer = CATextLayer()
    private var nameAttributedString : NSAttributedString?
    {
        guard let name = self.name else { return nil }
        return NSAttributedString(string: name, attributes: self.nameAttributes)
    }
    private var dragStart   : NSPoint?
    private var dragOffset  : NSPoint?
    
    // MARK: - Initializers
    convenience init(withName initialName: String)
    {
        let frame = NSRect(origin: CGPoint.zero, size: NodeView.minSize)
        self.init(frame: frame)
        self.name = initialName
    }
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
//      Initialize layers
        self.wantsLayer = true
        self.layer = NodeView.newNodeLayer()
        self.nameLayer = self.newNameLayer()
        self.layer?.addSublayer(self.nameLayer)
        // TODO: Versus (I: 🔅)
//        let layer = NodeView.newNodeLayer()
//        let nameLayer = self.newNameLayer()
//        layer.addSublayer(self.nameLayer)
//        self.layer = layer
//        self.nameLayer = nameLayer
    }
    
    // TODO: Implement (I: 🔆)
    required init?(coder decoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    class private func newNodeLayer() -> CALayer
    {
        let nodeLayer = CALayer()
        let nodeColor : CGColor = #colorLiteral(red: 0.1160337528, green: 0.8740647007, blue: 0.940814124, alpha: 1)
        
        nodeLayer.cornerRadius      = 8.0
        nodeLayer.borderWidth       = 1.0
        nodeLayer.borderColor       = nodeColor
        nodeLayer.backgroundColor   = nodeColor.copy(alpha: 0.35)
        nodeLayer.layoutManager     = NodeView.nodeConstraintLayoutManager
        
        return nodeLayer
    }
    
    // MARK: -
    // TODO: Combine `inPoint`, `outPoint`, `connectionY` with enum param for direction (I: 🔅)
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
    
    // MARK: -
    // TODO: static (I: 🔅)
    private func newNameLayer() -> CATextLayer
    {
        let nameLayer = CATextLayer()
        nameLayer.font              = NSFont.boldSystemFont(ofSize: 12.0)
        nameLayer.fontSize          = 12.0
        nameLayer.alignmentMode     = .center
        nameLayer.truncationMode    = .end
        nameLayer.foregroundColor   = NSColor.white.cgColor
        // TODO: Adjust on padding set (make padding computed property based on offsets of constriants?) (I: 🔅)
        nameLayer.addConstraint(CAConstraint(attribute:    .minX,
                                             relativeTo:   "superlayer",
                                             attribute:    .minX,
                                             offset:       self.padding.left))
        nameLayer.addConstraint(CAConstraint(attribute:    .maxX,
                                             relativeTo:   "superlayer",
                                             attribute:    .maxX,
                                             offset:       -self.padding.right))
        nameLayer.addConstraint(CAConstraint(attribute:    .midY,
                                             relativeTo:   "superlayer",
                                             attribute:    .midY))
        return nameLayer
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
            + (self.layer?.cornerRadius ?? 0.0)
            + (NodeView.connectionSpacing * CGFloat(viewIndex))
    }
    
    private func repositionNode()
    {
        guard let nodeMapView = self.nodeMapView else { return }
        let newOrigin = CGPoint(x: max(self.frame.origin.x,
                                       (nodeMapView.margins.left + NodeMapView.arrowClearance)),
                                y: max(self.frame.origin.y,
                                       (nodeMapView.margins.top + NodeMapView.arrowClearance)))
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
    }
    
    private func resizeNode()
    {
//      Caluclate height based on the most number of connections on a side
        let maxConnectionPerSide = max(self.inConnections.count, self.outConnections.count)
        let currentBorderWidth = self.layer?.borderWidth ?? 0.0
        let currentCornerRadius = self.layer?.cornerRadius ?? 0.0
        let nodeHeight  = 2.0 * (currentCornerRadius + currentBorderWidth)
            + (CGFloat(max(maxConnectionPerSide - 1, 0)) * NodeView.connectionSpacing)
//      Calculate width based on node name
        let maxStringSize = self.nameAttributedString?.size() ?? NSSize.zero
        let nodeWidth = ceil(maxStringSize.width) + self.padding.left + self.padding.right
        self.frame.size = NSSize(
            width:  nodeWidth.clamped(to: NodeView.minSize.width...NodeView.maxSize.width),
            height: nodeHeight.clamped(to: NodeView.minSize.height...NodeView.maxSize.height))
//      Recalculate name layer height
        self.nameLayer.frame.size.height = maxStringSize.height
        
        self.nodeMapView?.refresh()
    }
    
    // MARK: - NSResponder methods
    public override func mouseDown(with event: NSEvent)
    {
        guard let startingDragPosition = self.superview?.convert(event.locationInWindow, from: nil)
            else { return }
        // TODO: Delta instead of offset (+ vs -) (I: 🔅)
        self.dragOffset = startingDragPosition - self.frame.origin
    }
    
    public override func mouseDragged(with event: NSEvent)
    {
        guard   let dragOffset = self.dragOffset,
                let currentDragLocation = self.superview?.convert(event.locationInWindow, from: nil)
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

// MARK: NSAnimationDelegate conformance
extension NodeView : NSAnimationDelegate
{
    func animation(_ animation: NSAnimation, valueForProgress progress: NSAnimation.Progress) -> Float
    {
        self.nodeMapView?.refresh()
        return progress
    }
}
