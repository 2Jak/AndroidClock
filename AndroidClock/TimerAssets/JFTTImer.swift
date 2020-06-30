//
//  JFTTImer.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 26/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTTimer: JFTJSONSerializable
{
    static var TimerStorage: [JFTTimer] = []
    var Hour: Int
    var Minute: Int
    var Second: Int
    var Label: String
    var CurrentHour: Int
    var CurrentMinute: Int
    var CurrentSecond: Int
    var Duration: Double
    {
        get
        {
            return Double((Hour * 3600)+(Minute * 60)+Second)
        }
    }
    
    required init()
    {
        Hour = 0
        Minute = 0
        Second = 0
        Label = ""
        CurrentHour = 0
        CurrentMinute = 0
        CurrentSecond = 0
    }
    init(hour: Int, minute: Int, second: Int)
    {
        Hour = hour
        Minute = minute
        Second = second
        Label = ""
        CurrentHour = hour
        CurrentMinute = minute
        CurrentSecond = second
    }
    
    func ResetTimer()
    {
        CurrentHour = Hour
        CurrentMinute = Minute
        CurrentSecond = Second
    }
    
    func ProcessTimerTick() -> Bool
    {
        return processSeconds()
    }
    
    private func processHours() -> Bool
    {
        if CurrentHour == 0
        {
            return true
        }
        else
        {
            CurrentHour -= 1
            return false
        }
    }
    
    private func processMinutes() -> Bool
    {
        if CurrentMinute == 0
        {
            return processHours()
        }
        else
        {
            CurrentMinute -= 1
            return false
        }
    }
    
    private func processSeconds() -> Bool
    {
        if CurrentSecond == 0
        {
            return processMinutes()
        }
        else
        {
            CurrentSecond -= 1
            return false
        }
    }
    
    static func AddTimer(timer: JFTTimer)
    {
        TimerStorage.append(timer)
        JFTTimer.SaveChanges()
    }
    
    static func RemoveTimer(row: Int)
    {
        TimerStorage.remove(at: row)
        JFTTimer.SaveChanges()
    }
    
    static func SaveChanges()
    {
        JFTUtilities.SaveLocalData(filename: "timers", objectToSave: TimerStorage)
    }
    
    func Serialize() -> Dictionary<String, Any>
    {
        return ["Hour":Hour,
                "Minute":Minute,
                "Second":Second,
                "Label":Label,
                "CurrentHour":CurrentHour,
                "CurrentMinute":CurrentMinute,
                "CurrentSecond":CurrentSecond]
    }
    
    func Deserialize(json: Dictionary<String, Any>)
    {
        Hour = json["Hour"] as! Int
        Minute = json["Minute"] as! Int
        Second = json["Second"] as! Int
        Label = json["Label"] as! String
        CurrentHour = json["CurrentHour"] as! Int
        CurrentMinute = json["CurrentMinute"] as! Int
        CurrentSecond = json["CurrentSecond"] as! Int
    }
}
