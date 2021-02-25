//
//  File.swift
//  
//
//  Created by Duncan Oliver on 2/25/21.
//

import SwiftUI

struct SUINodeView : View
{
  let nodeColor: NSColor = #colorLiteral(red: 0.1160337528, green: 0.8740647007, blue: 0.940814124, alpha: 1)

  @State var name : String

  var body: some View
  {
    Text(name)
      .foregroundColor(.white)
//      .foregroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
      .cornerRadius(8.0)
      .border(Color.gray, width: 1.0)
      .background(Color.gray)
//      .background(#colorLiteral(red: 0.1160337528, green: 0.8740647007, blue: 0.940814124, alpha: 1))
  }
}
