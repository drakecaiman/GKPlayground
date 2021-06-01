//
//  File.swift
//  
//
//  Created by Duncan on 5/29/21.
//

import Foundation
import SwiftUI
import Combine

class DragController : ObservableObject
{
//  @GestureState var offsetGS : CGFl
    @Published var offset : CGSize = .zero
  @Published var draggingStatus = [ String : Bool ]()
  
//  var drag : some Gesture
//  {
//    DragGesture(coordinateSpace: .named("parentNodeMapView"))
//      .onChanged
//      {
//        gesture in
//        self.offset = gesture.translation
////        self.isDragging = true
//      }
//      .onEnded
//      {
//        gesture in
//        self.nodeBody.frame.origin += CGPoint(x: gesture.translation.width,
//                                              y: gesture.translation.height)
//        self.offset = .zero
////        self.isDragging = false
//      }
//  }
  
  func setDragging(forID id: String)
  {
    self.draggingStatus[id] = !id.contains(":")
  }
  
  func setDragging(forIDs ids: [String])
  {
    for id in ids
    {
      self.setDragging(forID: id)
    }
  }
  
  func clearDragging()
  {
    self.offset = .zero
    self.draggingStatus = [ String : Bool ]()
  }
  
  func dragOffset(forViewWithID id: String) -> CGSize
  {
    if let dragStatus = self.draggingStatus[id],
       dragStatus != false
    {
      return self.offset
    }
    return .zero
  }
}
