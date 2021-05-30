//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/18/21.
//

import Foundation

struct ConnectionBody : Body, Identifiable
{
  let connection : Connection
  var frame : CGRect = .zero
  var id : String { self.connection.id }
}
