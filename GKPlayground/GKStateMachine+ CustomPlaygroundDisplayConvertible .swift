//
//  GKStateMachine+ CustomPlaygroundDisplayConvertible .swift
//  GKPlayground
//
//  Created by Duncan on 2/6/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import GameplayKit

extension GKState// : CustomPlaygroundDisplayConvertible
{
    public var playgroundDescription : Any
    {
        let stateRect = NSRect(origin: .zero, size: NodeView.defaultNodeSize)
        let stateNodeView = NodeView(frame: stateRect)
        stateNodeView.name = String(describing: type(of: self))
        
        return stateNodeView
    }
    
    // TODO: move 'playgroundDescription' here?
    public var stateView : NSView
    {
        return NSView()
    }
}

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
        var connections = [String : Set<String>]()
        for currentState in self
        {
            let currentStateName = String(describing: type(of: currentState))
            for outState in self
            {
                guard currentState.isValidNextState(type(of: outState)) else { continue }
                let outStateName = String(describing: type(of: outState))
                if connections[currentStateName] == nil
                {
                    connections[currentStateName] = Set<String>()
                }
                connections[currentStateName]?.insert(outStateName)
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
        var nodeOrigin = CGPoint(x: NodeMapView.margin.width + NodeMapView.arrowClearance,
                                 y: NodeMapView.margin.height + NodeMapView.arrowClearance)
        
//      Create node view for each state
        for nextState in self
        {
            let nextStateName = String(describing: type(of: nextState))
            let nextViewFrame = NSRect(origin: nodeOrigin, size: NodeView.defaultNodeSize)
            let nextView = NodeView(frame: nextViewFrame)
            nextView.name = nextStateName
            
            view.addSubview(nextView)
            nodeViews[nextStateName] = nextView
            nodeOrigin.x = nextViewFrame.maxX + nodeSpacing
            nodeOrigin.y =  nextViewFrame.minY
                            + NodeView.defaultNodeSize.height
                            + nodeSpacing
        }
        
//      Connect views based on state transistions
        for nextEnterState in self
        {
            let nextEnterStateName = String(describing: type(of: nextEnterState))
            guard let nextEnterView = nodeViews[nextEnterStateName] else { continue }
            for nextExitStateName in connections[nextEnterStateName] ?? []
            {
                guard let nextExitView = nodeViews[nextExitStateName] else { continue }
                nextEnterView.outConnections.append(nextExitView)
                nextExitView.inConnections.append(nextEnterView)
            }
        }
        
        return nodeScrollView
    }
}
