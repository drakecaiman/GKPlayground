//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/18/21.
//

import Foundation

public struct NodeBody : Body, Identifiable
{
  static let PORT_SPACING : CGFloat = 8.0

  let node : Node
  public var frame : CGRect
  public var id : String { self.node.id }

  func update()
  {
    
  }

  //TODO: Should port IDs be unique per-node or side (in vs. out)? If per side, how do you diff.?
  //TODO: Error?
  public func positionForPort(withID id: String) -> CGPoint?
  {
    
    var position : CGPoint? = nil
//  TODO: Generalize
//  TODO: Rethink positioning of port start
    if let inIndex = self.node.inIDs?.firstIndex(of: id)
    {
      position = CGPoint(x: self.frame.minX,
                         y: self.frame.midY + CGFloat(inIndex) * NodeBody.PORT_SPACING)
    }
    else if let outIndex = self.node.outIDs?.firstIndex(of: id)
    {
      position = CGPoint(x: self.frame.maxX,
                         y: self.frame.midY + CGFloat(outIndex) * NodeBody.PORT_SPACING)
    }

    return position
  }
}

// MARK: Initializers
extension NodeBody
{
  public init(withNode node: Node)
  {
    self.node = node
    self.frame = CGRect(origin: .zero, size: CGSize(width: 100.0, height: 50.0))
  }
}
