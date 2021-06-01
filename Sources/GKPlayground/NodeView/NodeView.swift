//
//  File.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import SwiftUI

public struct NodeView : View, Identifiable
{
  /// The spacing on each side between the text of the `NodeView` and its borders
  static let padding = EdgeInsets(top: 4.0, leading: 4.0, bottom: 4.0, trailing: 4.0)
  // MARK: -
  @State var textColor : Color = .black
  @State var nodeColor : Color = .white
  @Binding var nodeBody : NodeBody
  @Binding var bodyMap : BodyMap?

  public var id : String { self.nodeBody.node.id }

  @EnvironmentObject private var dragController : DragController

  @State private var isDragging = false

  //TODO: Reposition to always be in the superview bounds
  //TODO: Resize to accomodate ports and name
  public var body : some View
  {
    ZStack
    {
      baseShape()
        .strokeBorder()
        .foregroundColor(.black)
        .background(baseShape()
                      .foregroundColor(nodeColor))
      Text(self.nodeBody.node.name ?? "Untitled")
        .fontWeight(.bold)
        .foregroundColor(textColor)
        .padding(NodeView.padding)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .frame(width: nodeBody.frame.width, height: nodeBody.frame.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    .position(nodeBody.frame.center)
//    .opacity(self.isDragging ? 0.5 : 1.0)
    .gesture(self.drag)
    //  TOOD: Use ideal instead?
    //    .frame(minWidth: 24.0, idealWidth: 64.0, maxWidth: .infinity,
    //           minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0,
    //           alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    //    .position(nodeBody.frame)
  }

//TODO: Selection based move (on click select related bodies and update)?
  private var drag : some Gesture
  {
    DragGesture(coordinateSpace: .named("parentNodeMapView"))
      .onChanged
      {
        gesture in
        self.dragController.offset = gesture.translation
        if let relatedBodyKeys = self.bodyMap?.idBodyDictionary.keys.filter { $0.contains(id) }
        {
          self.dragController.setDragging(forIDs: relatedBodyKeys)
        }
      }
      .onEnded
      {
        gesture in
        self.nodeBody.frame.origin += CGPoint(x: gesture.translation.width,
                                              y: gesture.translation.height)
        self.dragController.clearDragging()
      }
  }

  private func baseShape() -> RoundedRectangle
  {
    return RoundedRectangle(cornerRadius: 8.0, style: .continuous)
  }
}

// MARK: Initializers
extension NodeView
{
//  public init(withNodeBody nodeBody: Binding<NodeBody>)
//  {
//    self.init(nodeBody: nodeBody)
//  }
}
