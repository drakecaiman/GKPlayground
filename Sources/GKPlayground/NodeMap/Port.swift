//
//  File.swift
//  
//
//  Created by Duncan Oliver on 3/9/21.
//

import Foundation

public struct Port : Identifiable, Element
{
  let name : String
  let parentID : Node.ID
  var connectionIDs = [Connection.ID]()
  public var id : String { "\(parentID).\(name)" }
}

// MARK: ProducesBody
extension Port
{
  public var body : Body { PortBody(port: self) }
}
