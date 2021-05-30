//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/27/21.
//

import Foundation

public struct PortBody : Body, Identifiable
{
  let port : Port
  public var frame : CGRect = .zero
  public var id : String { self.port.id }
}
