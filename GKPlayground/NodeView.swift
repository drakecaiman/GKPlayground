//
//  NodeView.swift
//  GKPlayground
//
//  Created by Duncan on 2/10/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

public class NodeView : NSView
{
    static let defaultNodeSize = CGSize(width: 100.0, height: 32.0)
    
    let nodePadding     : CGFloat   = 4.0
    let nodeBorderWidth : CGFloat   = 1.0
    
    public var name         : String?
    public var nodeColor    : NSColor = .blue
    public var textColor    : NSColor = .white
    
    // TODO: Make weak collections
    public var inConnections    = [NodeView]()
    public var outConnections   = [NodeView]()
    
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
//        stateNodePath.fill()
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
}
