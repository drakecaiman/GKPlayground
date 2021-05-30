//
//  File.swift
//  
//
//  Created by Duncan Oliver on 4/18/21.
//

import Foundation
import SwiftUI

enum BodyMapError : Error
{
  case bodyNotFound
}

public struct BodyMap
{
  static let NODE_SPACING : CGFloat = 20.0
  static let PORT_SPACING : CGFloat = 8.0

  var idBodyDictionary = [String : Body]()

  var bodies : [Body] { Array(self.idBodyDictionary.values) }

//TODO: KeyPath instead of subscript (dynamicMember)?
//  subscript(index: String) throws -> Body? { self.idBodyDictionary[index] }

  public func body(forID id: String) throws -> Body
  {
    guard let body = self.idBodyDictionary[id] else
    {
      throw BodyMapError.bodyNotFound
    }
    return body
  }
}

// MARK: Initializers
extension BodyMap
{
  public init(withNodeMap nodeMap: NodeMap)
  {
    self.idBodyDictionary = Dictionary(uniqueKeysWithValues: nodeMap.contents.map { ($0, $1.body) } )
    var nextPosition = CGPoint.zero
//  Position nodes
    for var nextNodeBody in self.idBodyDictionary.compactMap({ $1 as? NodeBody })
    {
      nextNodeBody.frame.origin = nextPosition
      for nextInID in nextNodeBody.node.inIDs ?? []
      {
        guard var nextPortBody = self.idBodyDictionary[nextInID],
              let nextNodePosition = nextNodeBody.positionForPort(withID: nextPortBody.id)
        else { continue }
        nextPortBody.frame.origin = nextNodePosition
        self.idBodyDictionary[nextInID] = nextPortBody
      }
      for nextOutID in nextNodeBody.node.outIDs ?? []
      {
        guard var nextPortBody = self.idBodyDictionary[nextOutID],
              let nextNodePosition = nextNodeBody.positionForPort(withID: nextPortBody.id)
        else { continue }
        nextPortBody.frame.origin = nextNodePosition
        self.idBodyDictionary[nextOutID] = nextPortBody
      }
      self.idBodyDictionary[nextNodeBody.id] = nextNodeBody
      nextPosition = CGPoint(x: nextNodeBody.frame.maxX + BodyMap.NODE_SPACING,
                             y: nextNodeBody.frame.maxY + BodyMap.NODE_SPACING)
    }
  }

//TODO: Reconciling function for positioning bodies
}

// MARK: Mock
extension BodyMap
{
  static var BODY_MAP : BodyMap { BodyMap(withNodeMap: .NODE_MAP) }
}
