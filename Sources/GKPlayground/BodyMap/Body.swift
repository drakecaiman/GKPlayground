//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/27/21.
//

import Foundation

// TODO: Replace separate body structs with concrete Body with reference to representation
public protocol Body
{
  var id : String { get }
  var frame : CGRect { get set }
}
