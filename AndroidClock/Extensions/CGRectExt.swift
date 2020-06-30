//
//  CGRectExt.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 30/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

extension CGRect
{
    static func -(rect: CGRect, scalar: CGFloat) -> CGRect
    {
        return CGRect(x: rect.origin.x + (scalar / 2), y: rect.origin.y + (scalar / 2), width: rect.size.width - scalar, height: rect.size.height - scalar)
    }
}
