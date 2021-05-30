//
//  NodeMapView.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import SwiftUI

public struct NodeMapView : View
{
  private enum ViewDepth : Double
  {
    case node
    case port
    case connection
  }

  // MARK: State
//TODO: ObservedObject?
  @State public var bodyMap : BodyMap

  @GestureState private var isDragging : Bool = false

  // MARK: -
  /// The distance on each side between the content of this view and its edges
  public var margins = EdgeInsets(top: 12.0, leading: 12.0, bottom: 12.0, trailing: 12.0)
  
  public var body : some View
  {
    let frame = self.frameContainingAllBodies()
    ZStack {
      ForEach(self.bodyMap.bodies, id:\.id)
      {
        body in
        self.view(forBody: body)
      }
    }
    .frame(width: frame.width, height: frame.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    .padding(self.margins)
    .coordinateSpace(name: "parentNodeMapView")
    .background(self.isDragging ? Color.green : Color.clear)
    .gesture(DragGesture()
              .updating($isDragging)
              {
                gesture, state, transaction in
                state = true
              })
  }

  //TODO: Move (to extension)?
  //TODO: Static?
  //TODO: Move to each conforming `Body` struct
  @ViewBuilder
  private func view(forBody body: Body) -> some View
  {
    if let nodeBody = body as? NodeBody
    {
      let nodeBodyBinding = Binding(
        get: { nodeBody },
        set:
          {
            self.bodyMap.idBodyDictionary[nodeBody.id] = $0;
            self.update(forID: nodeBody.id)
          }
      )
      NodeView(nodeBody: nodeBodyBinding)
        .zIndex(ViewDepth.node.rawValue)
    }
    else if let portBody = body as? PortBody
    {
      let portBodyBinding = Binding(
        get: { portBody },
        set: { self.bodyMap.idBodyDictionary[portBody.id] = $0 }
      )
      PortView(portBody: portBodyBinding)
        .zIndex(ViewDepth.port.rawValue)
    }
    else if let connectionBody = body as? ConnectionBody
    {
      let connectionBodyBinding = Binding(
        get: { connectionBody },
        set: { self.bodyMap.idBodyDictionary[connectionBody.id] = $0 }
      )
      let mapBinding = Binding(
        get: { self.bodyMap },
        set: { self.bodyMap = $0 }
      )
      ConnectionView(bodyMap: mapBinding, connectionBody: connectionBodyBinding)
        .zIndex(ViewDepth.connection.rawValue)
    }
  }

  private func update(forID id: String)
  {
//  TODO: Make sure nodes are updated before connections
    let relatedBodyKeys = self.bodyMap.idBodyDictionary.keys.filter
    { $0.contains(id) }
    let relatedBodies = self.bodyMap.idBodyDictionary.filter
    {
      key, _ in
      relatedBodyKeys.contains(key)
    }
    for (id, body) in relatedBodies
    {
      if var portBody = body as? PortBody
      {
        guard let nodeBody = self.bodyMap.idBodyDictionary[portBody.port.parentID] as? NodeBody,
              let position = nodeBody.positionForPort(withID: id)
        else { continue }
        portBody.frame.center = position
//        for nextConnection in portBody.port.connectionIDs
//        {
//          guard let connectionBody = self.bodyMap.idBodyDictionary[nextConnection] as? ConnectionBody else { continue }
//          connectionBody
//          self.bodyMap.idBodyDictionary[nextConnection] =
//            connectionBody
//        }
//      TODO: Replace direct dictionary call with `save` method
        self.bodyMap.idBodyDictionary[id] = portBody

      }
//      else if var connectionBody = body as? ConnectionBody
//      {
//        connectionBody.bodyMap
//        self.bodyMap.idBodyDictionary[id] = connectionBody
////        connectionBody.connection.inID
////        if connectionBody.connection.inID == id
////        {
////
//        }
//        else if connectionBody.connection.outID == id
//        guard portBody = self.bodyMap.idBodyDictionary[portBody.port.parentID]
//      }
    }
  }

  private func frameContainingAllBodies() -> CGRect
  {
    return CGRect.union(self.bodyMap.idBodyDictionary.values.map { $0.frame })
  }
}

// MARK: Initializers
extension NodeMapView
{
  public init(withBodyMap bodyMap: BodyMap)
  {
    self.init(bodyMap: bodyMap)
  }
}

struct SUINodeMapView_Previews : PreviewProvider
{
  static var previews: some View
  {
    ScrollView([.horizontal, .vertical], showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    {
      NodeMapView(withBodyMap: .BODY_MAP)
    }
  }
}
