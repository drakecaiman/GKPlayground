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
