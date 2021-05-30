//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/6/21.
//

import Foundation

struct Connection : Identifiable, Element
{
  let inID : Port.ID
  let outID : Port.ID
  var id : String { "\(inID):\(outID)" }
}

// MARK: ProducesBody
extension Connection
{
  var body : Body { ConnectionBody(connection: self) }
}
