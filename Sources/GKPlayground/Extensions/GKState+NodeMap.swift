//
//  File.swift
//  
//
//  Created by Duncan Oliver on 5/3/21.
//

import GameplayKit

extension GKState
{
//TODO: Pascal case conversion (I: 🔆)
  public var node : Node { Node(withName: String(describing: type(of: self))) }
  public var nodeBody : NodeBody { NodeBody(withNode: node) }
  public var nodeView : NodeView { NodeView(nodeBody: .constant(self.nodeBody)) }

  func validNextStates(fromStates states : [GKState]) -> [GKState]
  {
    return states.filter { self.isValidNextState(type(of: $0)) }
  }
}
