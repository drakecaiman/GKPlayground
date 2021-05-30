//
//  GKStateMachine+CustomPlaygroundDisplayConvertible.swift
//  GKPlayground
//
//  Created by Duncan on 2/6/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import GameplayKit
import SwiftUI

extension GKState : CustomPlaygroundDisplayConvertible
{
	public var playgroundDescription: Any
	{
    return self.nodeView
	}
}

extension Array : CustomPlaygroundDisplayConvertible where Element == GKState
{
  @ViewBuilder
  public var nodeMapView : some View
  {
    let nodeMap = NodeMap(fromStates: self)
    let bodyMap = BodyMap(withNodeMap: nodeMap)
    NodeMapView(withBodyMap: bodyMap)
  }

  public var playgroundDescription : Any { self.nodeMapView }
}
