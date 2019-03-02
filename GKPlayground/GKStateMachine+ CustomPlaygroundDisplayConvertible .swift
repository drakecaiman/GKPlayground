//
//  GKStateMachine+ CustomPlaygroundDisplayConvertible .swift
//  GKPlayground
//
//  Created by Duncan on 2/6/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import GameplayKit

extension GKState: CustomPlaygroundDisplayConvertible
{
	public var playgroundDescription: Any
	{
		return self.stateNodeView
	}
	
	// TODO: Make public? (I: 🔅)
	/// A `NodeView` formatted and populated to represent this state.
	var stateNodeView: NodeView
	{
		let stateName = String(describing: type(of: self))
		return NodeView(withName: stateName)
	}
}

// TODO: Implement (LiveViewMessageHandler)? (II: 🔆)
//extension GKStateMachine : CustomPlaygroundDisplayConvertible
//{
//    public var playgroundDescription: Any
//    {
//        return NSView()
//    }
//}

extension Array: CustomPlaygroundDisplayConvertible where Element == GKState
{
	public var playgroundDescription: Any
	{
		let scrollViewRect = CGRect(x: 0, y: 0, width: 600, height: 400)
		let nodeScrollView = NSScrollView(frame: scrollViewRect)
		nodeScrollView.drawsBackground = false
		nodeScrollView.documentView = self.stateNodeMapView
		nodeScrollView.hasVerticalScroller = true
		nodeScrollView.hasHorizontalScroller = true
		
		return nodeScrollView
	}
	
	// TODO: Make public? (I: 🔅)
	var stateNodeMapView: NodeMapView
	{
//      Get connections between states
		var connections = [String : NSMutableOrderedSet]()
		for currentState in self
		{
			let currentStateName = String(describing: type(of: currentState))
			for outState in self
			{
				guard currentState.isValidNextState(type(of: outState)) else { continue }
				let outStateName = String(describing: type(of: outState))
				if connections[currentStateName] == nil
				{
					connections[currentStateName] = NSMutableOrderedSet()
				}
				connections[currentStateName]?.add(outStateName)
			}
		}
		
		var nodeViews = [String : NodeView]()
		let view = NodeMapView(frame: .zero)
		
		let nodeSpacing: CGFloat = 25.0
		var nodeOrigin = CGPoint(x: view.margins.left + NodeMapView.arrowClearance,
								 y: view.margins.top + NodeMapView.arrowClearance)
		
//      Create node view for each state
		for nextState in self
		{
			// TODO: Pascal case conversion (I: 🔆)
			let nextStateName = String(describing: type(of: nextState))
			guard nodeViews[nextStateName] == nil else { continue }
			let nextView = nextState.stateNodeView
			nextView.frame.origin = nodeOrigin
			
			view.addSubview(nextView)
			nodeViews[nextStateName] = nextView
			// TODO: Adjust origins after conntections are made? (I: 🔅)
			nodeOrigin.x =  nextView.frame.maxX + nodeSpacing
			nodeOrigin.y =  nextView.frame.maxY + nodeSpacing
		}
		
//      Connect views based on state transistions
		for nextEnterState in self
		{
			let nextEnterStateName = String(describing: type(of: nextEnterState))
			guard let nextEnterView = nodeViews[nextEnterStateName] else { continue }
			for case let nextExitStateName as String in connections[nextEnterStateName] ?? []
			{
				guard let nextExitView = nodeViews[nextExitStateName] else { continue }
				nextEnterView.outConnections.append(nextExitView)
				nextExitView.inConnections.append(nextEnterView)
			}
		}
		
		return view
	}
}

// TODO: PlaygroundLiveViewable defined in this file and not playground (I: 🔆)
//extension Array: PlaygroundLiveViewable where Element == GKState
//{
//	public playgroun
//}
