//
//  NSPoint+.swift
//  GKPlayground
//
//  Created by Duncan on 2/17/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

extension NSPoint
{
    static func +(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout NSPoint, rhs: NSPoint)
    {
        lhs = NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
