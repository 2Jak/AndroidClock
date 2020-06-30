//
//  JFTFormatter.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTFormatter
{
    private static var generalDateFormatter = DateFormatter()
    
    static func FormatMinutes(_ minutes: Int) -> String
    {
        if minutes < 10
        {
            return "0\(minutes)"
        }
        return "\(minutes)"
    }
    
    static func FormatStopperToString(_ stopper: JFTStopper) -> String
    {
        return "\(FormatMinutes(stopper.Minutes)):\(FormatMinutes(stopper.Seconds)).\(FormatMinutes(stopper.Miliseconds))"
    }
    
    static func FormatedTimeString(date: Date) -> String
    {
        generalDateFormatter.dateFormat = "HH:mm"
        return generalDateFormatter.string(from: date)
    }
    
    static func FormatedDateString(date: Date) -> String
    {
        generalDateFormatter.dateFormat = "E, d MMM"
        return generalDateFormatter.string(from: date)
    }
}
