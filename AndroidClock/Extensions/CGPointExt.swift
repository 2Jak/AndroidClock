//
//  CGPointExt.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 30/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

extension CGPoint
{
    static func -(a: CGPoint, b: CGPoint) -> CGPoint
    {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
}
