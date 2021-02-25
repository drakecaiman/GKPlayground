//
//  NodeMapView.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import SwiftUI

public struct SUINodeMapView : View
{
  // MARK: State
  @State var nodes : [Node]

  // MARK: Constants
  /// The length of each line segment used to draw the arrowhead of a connection line.
  public static let arrowheadLength   : CGFloat = 5.5
  /// The minimum distance for a connection line to travel out from a node before curving.
  public static let arrowClearance  : CGFloat = 12.0

  // MARK: -
  /// The distance on each side between the content of this view and its edges
  public var margins = NSEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
  /// The width to use when drawing connections between nodes.
  public var connectionLineWidth    : CGFloat = 2.7
  /// The color of node connection lines.
  public var connectionColor        : NSColor = #colorLiteral(red: 0.8694332242, green: 0.8694332242, blue: 0.8694332242, alpha: 1)

  public var body : some View
  {
    ForEach(self.nodes)
    {
      node in
      SUINodeView(name: node.name)
    }
  }
}
