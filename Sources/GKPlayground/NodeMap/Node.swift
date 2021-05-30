//
//  Node.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import Foundation

public struct Node : Identifiable, Element
{
  public var name : String?
  public var inIDs : [Port.ID]?
  public var outIDs : [Port.ID]?
  public let id : String = UUID().uuidString
}

// MARK: Initializers
extension Node
{
  public init(withName name: String)
  {
    self.name = name
  }
}

// MARK: ProducesBody
extension Node
{
  public var body : Body { NodeBody(withNode: self) }
}
