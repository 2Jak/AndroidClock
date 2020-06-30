//
//  JFTStopper.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 29/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTStopper
{
    var On: Bool = false
    var Miliseconds: Int = 0
    var Seconds: Int = 0
    var Minutes: Int = 0
    
    func ResetStopper()
    {
        Miliseconds = 0
        Seconds = 0
        Minutes = 0
    }
    
    func ProcessTick()
    {
        processMiliseconds()
    }
    
    private func processMiliseconds()
    {
        if Miliseconds >= 99
        {
            Miliseconds = 0
            processSeconds()
        }
        else
        {
            Miliseconds += 1
        }
    }
    
    private func processSeconds()
    {
        if Seconds >= 59
        {
            Seconds = 0
            processMinutes()
        }
        else
        {
            Seconds += 1
        }
    }
    
    private func processMinutes()
    {
        if Minutes >= 59
        {
            On = false
        }
        else
        {
            Minutes += 1
        }
    }
}
