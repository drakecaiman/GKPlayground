//
//  File.swift
//  
//
//  Created by Duncan Oliver on 5/9/21.
//

import Foundation

extension CGRectEdge
{
  var isMin : Bool { [CGRectEdge.minXEdge, CGRectEdge.minYEdge].contains(self) }
  var isMax : Bool { [CGRectEdge.maxXEdge, CGRectEdge.maxYEdge].contains(self) }
  var isX : Bool { [CGRectEdge.minXEdge, CGRectEdge.maxXEdge].contains(self) }
  var isY : Bool { [CGRectEdge.minYEdge, CGRectEdge.maxYEdge].contains(self) }
}
