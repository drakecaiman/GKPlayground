//
//  SwiftUIView.swift
//  
//
//  Created by Duncan Oliver on 3/21/21.
//

import SwiftUI

struct PortView : View, Identifiable {
  var id : String { portBody.port.id }

  @Binding var portBody : PortBody

  var body: some View
  {
    Circle()
      .stroke(lineWidth: 2.0)
      .foregroundColor(.gray)
      .frame(width: 8.0, height: 8.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .position(portBody.frame.origin)
  }
}

struct OutletView_Previews: PreviewProvider
{
  static let node = Node(withName: "preview")
  static let port = Port(name: "preview", parentID: node.id, connectionIDs: [])
  static var previews: some View {
    //    TODO: Get center of screen
    //      let center =
    PortView(portBody: .constant(PortBody(port: port)))
  }
}
