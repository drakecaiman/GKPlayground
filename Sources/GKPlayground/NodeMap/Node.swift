//
//  Node.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import Foundation

struct Node : Identifiable
{
  var id : UUID = UUID()
  var name : String
  var input : [Node]?
  var output : [Node]?
}
