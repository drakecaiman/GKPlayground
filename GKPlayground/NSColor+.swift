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
	/**
	 Initializes a new `NSColor` from a six-digit hexadecimal number.
	
	 - Parameter int: The hexadecimal value of the color.
	
	 - Returns: A new `NSColor` whose red component is based on the 1st two digits, the green
				component is based on the second two digits, and the blue component is based on the
				third digits of the provided hexadecimal. Its alpha component is `1.0`.
	 */
	public convenience init(fromInt int: Int)
	{
		let red     = CGFloat((int & (0xff << 16)) >> 16) / 255.0
		let green   = CGFloat((int & (0xff << 08)) >> 08) / 255.0
		let blue    = CGFloat((int & (0xff << 00)) >> 00) / 255.0
		self.init(red: red, green: green, blue: blue, alpha: 1.0)
	}
}

// TODO: UIColor equivalent? (II:  🔅)
// TODO: CGColor equivalent? (II:  🔅)
