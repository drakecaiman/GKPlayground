//
//  NSColor+.swift
//  GKPlayground
//
//  Created by Duncan on 2/13/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

extension NSColor
{
    public convenience init(fromInt int: Int)
    {
        let red     = CGFloat((int & (0xff << 16)) >> 16) / 255.0
        let green   = CGFloat((int & (0xff << 08)) >> 08) / 255.0
        let blue    = CGFloat((int & (0xff << 00)) >> 00) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
