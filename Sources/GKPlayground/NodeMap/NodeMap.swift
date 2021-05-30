//
//  File.swift
//  
//
//  Created by Duncan Oliver on 5/3/21.
//

import Foundation

public struct NodeMap
{
  var contents = [String : Element]()
}

extension NodeMap
{
  public init(withContents contents: [(String, Element)])
  {
    self.contents = Dictionary(uniqueKeysWithValues: contents)
  }
}

// MARK: Mock
extension NodeMap
{
  static var NODE_MAP : NodeMap
  {
//  TODO: Reconciling function for finding matching ports, connections, etc.
    var NODE_1 = Node(withName: "Node 1")
    var NODE_2 = Node(withName: "Node 2")
    var NODE_3 = Node(withName: "Node 3")
    let PORT_1_OUT = Port(name: "out", parentID: NODE_1.id)
    let PORT_2_IN = Port(name: "in", parentID: NODE_2.id)
    let PORT_2_OUT = Port(name: "out", parentID: NODE_2.id)
    let PORT_3_IN = Port(name: "in", parentID: NODE_3.id)
    let CXN_1_2 = Connection(inID: PORT_1_OUT.id, outID: PORT_2_IN.id)
    let CXN_2_3 = Connection(inID: PORT_2_OUT.id, outID: PORT_3_IN.id)

    NODE_1.outIDs = [PORT_1_OUT.id]
    NODE_2.inIDs = [PORT_2_IN.id]
    NODE_2.outIDs = [PORT_2_OUT.id]
    NODE_3.inIDs = [PORT_3_IN.id]

    return NodeMap(withContents: [
      (NODE_1.id, NODE_1),
      (NODE_2.id, NODE_2),
      (NODE_3.id, NODE_3),
      (PORT_1_OUT.id, PORT_1_OUT),
      (PORT_2_IN.id, PORT_2_IN),
      (PORT_2_OUT.id, PORT_2_OUT),
      (PORT_3_IN.id, PORT_3_IN),
      (CXN_1_2.id, CXN_1_2),
      (CXN_2_3.id, CXN_2_3)
    ])
  }
}
