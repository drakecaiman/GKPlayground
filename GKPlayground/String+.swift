//
//  NSString+.swift
//  GKPlayground
//
//  Created by Duncan on 2/17/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Foundation

extension String
{
    /**
     Returns the characters of this `String` as an array of `CGGlyph` instances from the given
	 `NSFont`.
     
     - Parameter font: The source font for the glyphs.
     
     - Returns: A `CGGlyph` array representing the characters of this string.
     */
    public func cgGlyphs(forFont font: NSFont) -> [CGGlyph]
    {
        var glyphs = [CGGlyph]()
        
        for c in self
        {
            let nextGlyph = font.glyph(withName: String(c))
            glyphs.append(CGGlyph(nextGlyph))
        }
        
        return glyphs
    }
}
