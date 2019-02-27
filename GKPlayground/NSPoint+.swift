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
    /**
     Add the matching components of two `NSPoint` instances and return the sums as a new point
     
     - Parameter lhs: The `NSPoint` to the left of the operator.
     - Parameter rhs: The `NSPoint` to the right of the operator.
     
     - Returns: A new `NSPoint` composed of the sum of each given point's components.
     */
    static func +(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    /**
     Subtract the matching components of two `NSPoint` instances and return the difference as a new point
     
     - Parameter lhs: The `NSPoint` to the left of the operator.
     - Parameter rhs: The `NSPoint` to the right of the operator.
     
     - Returns: A new `NSPoint` composed of the difference between each given point's components.
     */
    static func -(lhs: NSPoint, rhs: NSPoint) -> NSPoint
    {
        return NSPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    /**
     Increments the components of the left-hand `NSPoint` by the components of the right-hand one.
     
     - Parameter lhs: The `NSPoint` to the left of the operator, which will be incremented.
     - Parameter rhs: The `NSPoint` to the right of the operator; the incrementation value.
     */
    static func +=(lhs: inout NSPoint, rhs: NSPoint)
    {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
