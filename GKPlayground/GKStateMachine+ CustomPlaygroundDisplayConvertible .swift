//
//  GKStateMachine+ CustomPlaygroundDisplayConvertible .swift
//  GKPlayground
//
//  Created by Duncan on 2/6/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import GameplayKit

extension GKState : CustomPlaygroundDisplayConvertible
{
    public var playgroundDescription : Any
    {
        return self.stateNodeView
    }
    
    var stateNodeView : NodeView
    {
        let stateName = String(describing: type(of: self))
        return NodeView(withName: stateName)
    }
}

// TODO: Implement (LiveViewMessageHandler)? (II: 🔆)
extension GKStateMachine// : CustomPlaygroundDisplayConvertible
{
    public var playgroundDescription: Any
    {
        return NSView()
    }
}

extension Array : CustomPlaygroundDisplayConvertible where Element == GKState
{
    public var playgroundDescription : Any
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
        let viewRect = NSRect(x: 0, y: 0, width: 800, height: 800)
        let view = NodeMapView(frame: viewRect)
        let scrollViewRect = NSRect(x: 0, y: 0, width: 400, height: 400)
        let nodeScrollView = NSScrollView(frame: scrollViewRect)
        nodeScrollView.drawsBackground = false
        nodeScrollView.documentView = view
        nodeScrollView.hasVerticalScroller = true
        nodeScrollView.hasHorizontalScroller = true
        
        let nodeSpacing : CGFloat = 25.0
        var nodeOrigin = CGPoint(x: view.margins.left + NodeMapView.arrowClearance,
                                 y: view.margins.top + NodeMapView.arrowClearance)
        
//      Create node view for each state
        for nextState in self
        {
            let nextStateName = String(describing: type(of: nextState))
            guard nodeViews[nextStateName] == nil else { continue }
            let nextView = nextState.stateNodeView
            nextView.frame.origin = nodeOrigin
            // TODO: Pascal case conversion (I: 🔆)
            
            view.addSubview(nextView)
            nodeViews[nextStateName] = nextView
            nodeOrigin.x =  nextView.frame.maxX + nodeSpacing
            nodeOrigin.y =  nextView.frame.minY
                            + NodeView.minSize.height
                            + nodeSpacing
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
        
        return nodeScrollView
    }
}
