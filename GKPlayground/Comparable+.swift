//
//  Comparable+.swift
//  GKPlayground
//
//  Created by Duncan on 2/23/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

extension Comparable
{
    /**
     Returns this value, restricted to the given range.
     
     - Parameter range: The clamping `ClosedRange`.
     
     - Returns: The given value, adjust to fall in the given range. If the value is less than the
				lower bound of the range, the lower bound will be returned. If the value is greater
				than the upper bound of the range, the upper bound will be returned. Otherwise, the
				value will be returned.
     */
    public func clamped(to range: ClosedRange<Self>) -> Self
    {
        return self < range.lowerBound ? range.lowerBound :
            self > range.upperBound ? range.upperBound :
        self
    }
}
