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
    func clamped(to range: ClosedRange<Self>) -> Self
    {
        return self < range.lowerBound ? range.lowerBound :
        self > range.upperBound ? range.upperBound :
        self
    }
}
