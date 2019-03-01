//
//  CGPoint+.swift
//  GKPlayground
//
//  Created by Duncan on 2/17/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

extension CGPoint
{
	/**
	 Add the matching components of two `CGPoint` instances and return the sums as a new point.
	
	 - Parameter lhs: The `CGPoint` to the left of the operator.
	 - Parameter rhs: The `CGPoint` to the right of the operator.
	
	 - Returns: A new `CGPoint` composed of the sum of each given point's components.
	 */
	public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint
	{
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	/**
	 Subtract the matching components of two `CGPoint` instances and return the difference as a new
	 point
	
	 - Parameter lhs: The `CGPoint` to the left of the operator.
	 - Parameter rhs: The `CGPoint` to the right of the operator.
	
	 - Returns: A new `CGPoint` composed of the difference between each given point's components.
	 */
	public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint
	{
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	/**
	 Increments the components of the left-hand `CGPoint` by the components of the right-hand one.
	
	 - Parameter lhs: The `CGPoint` to the left of the operator, which will be incremented.
	 - Parameter rhs: The `CGPoint` to the right of the operator; the incrementation value.
	 */
	public static func +=(lhs: inout CGPoint, rhs: CGPoint)
	{
		lhs.x += rhs.x
		lhs.y += rhs.y
	}
	
	/**
	 Decrements the components of the left-hand `CGPoint` by the components of the right-hand one.
	
	 - Parameter lhs: The `CGPoint` to the left of the operator, which will be decremented.
	 - Parameter rhs: The `CGPoint` to the right of the operator; the decrementation value.
	 */
	public static func -=(lhs: inout CGPoint, rhs: CGPoint)
	{
		lhs.x -= rhs.x
		lhs.y -= rhs.y
	}
}
