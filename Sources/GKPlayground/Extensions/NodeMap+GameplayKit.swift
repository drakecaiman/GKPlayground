//
//  File.swift
//  
//
//  Created by Duncan Oliver on 5/9/21.
//

import GameplayKit

extension NodeMap
{
//  public init(fromStates states: GKState...)
  public init(fromStates states: [GKState])
  {
    var tempConnections = [Connection]()
    var nodes = [Node]()
    var connections = [Connection]()
    var ports = [Port]()
    var stateNameNodeIDMap = [String : String]()

    for nextState in states
    {
//    Add node for state
      let node = nextState.node
      nodes.append(node)
      stateNameNodeIDMap[nextState.className] = node.id
//    Add temp outgoing connection for this state
      let outConnections = nextState.validNextStates(fromStates: states).map { Connection(inID: nextState.className,
                                                                                          outID: $0.className) }
      tempConnections.append(contentsOf: outConnections)
    }
    connections = tempConnections.compactMap
    {
      connection in
      guard let inID = stateNameNodeIDMap[connection.inID],
            let outID = stateNameNodeIDMap[connection.outID]
//    TODO: Add warning
      else { return nil }
      return Connection(inID: inID + ".out", outID: outID + ".in")
    }
//  Add ports
//  !!!: Do not modify `nextNodeIndex`
//  TODO: Consider looping through indices only, grabbing nextNode in loop
    for var (nextNodeIndex, nextNode) in nodes.enumerated()
    {
      let outgoing = connections.filter { $0.inID.starts(with: nextNode.id ) }
      let incoming = connections.filter { $0.outID.starts(with: nextNode.id ) }
      nextNode.inIDs = incoming.map { $0.outID }
      if outgoing.count > 0
      {
        let connectedIDs = outgoing.map { $0.id }
        let port = Port(name: "out", parentID: nextNode.id, connectionIDs: connectedIDs)
        ports.append(port)
        nextNode.outIDs = [port.id]
      }
      if incoming.count > 0
      {
        let connectedIDs = incoming.map { $0.id  }
        let port = Port(name: "in", parentID: nextNode.id, connectionIDs: connectedIDs)
        ports.append(port)
        nextNode.inIDs = [port.id]
      }
      nodes[nextNodeIndex] = nextNode
    }
//  TODO: Cleanup (consolidate?)
    for nextNode in nodes
    {
      self.contents[nextNode.id] = nextNode
    }
    for nextPort in ports
    {
      self.contents[nextPort.id] = nextPort
    }
    for nextConnection in connections
    {
      self.contents[nextConnection.id] = nextConnection
    }
  }
}
