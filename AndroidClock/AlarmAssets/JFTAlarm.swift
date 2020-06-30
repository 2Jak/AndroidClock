//
//  JFTAlarm.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 26/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAlarm: JFTJSONSerializable
{
    static var AlarmStorage: [JFTAlarm] = []
    private var id: String
    var Hour: Int
    var Minute: Int
    var On: Bool
    {
        didSet
        {
            if On
            {
                addAllNotifications()
            }
            else
            {
                removeAllNotifications()
            }
        }
    }
    var Repeats: [Int]
    var Lable: String
    
    required init()
    {
        Hour = 0
        Minute = 0
        On = false
        Repeats = []
        Lable = ""
        id = ""
    }
    init(hour: Int, minute: Int)
    {
        Hour = hour
        Minute = minute
        On = false
        Repeats = []
        Lable = ""
        id = "Alarm\(UserDefaults.standard.integer(forKey: "LastAlarmCount"))"
    }
    
    func RemoveRepeat(weekday: Int)
    {
        if Repeats.contains(weekday)
        {
            Repeats.remove(at: Repeats.firstIndex(of: weekday)!)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id+"\(weekday)"])
        }
        JFTAlarm.SaveChanges()
    }
    
    private func removeAllNotifications()
    {
        var identifiers: [String] = [id]
        for i in 1...7
        {
            identifiers.append(id+"\(i)")
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func addAllNotifications()
    {
        if Repeats.count == 0
        {
            let notificationRequest = buildNotification()
            UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
        }
        else
        {
            for weekday in Repeats
            {
                let notificationRequest = buildNotification(weekday: weekday)
                UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
            }
        }
        
    }
    
    private func buildNotification(weekday: Int? = nil) -> UNNotificationRequest
    {
        let content = UNMutableNotificationContent()
        content.title = Lable
        content.sound = .defaultCritical
        let dateComponents = (weekday != nil) ? DateComponents(hour: Hour, minute: Minute, weekday: weekday) : DateComponents(hour: Hour, minute: Minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: (weekday != nil) ? true : false)
        let identifier = (weekday != nil) ? id+"\(weekday!)" : id
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
    static func AddAlarm(alarm: JFTAlarm)
    {
        let alarmCount = UserDefaults.standard.integer(forKey: "LastAlarmCount") + 1
        UserDefaults.standard.set(alarmCount, forKey: "LastAlarmCount")
        AlarmStorage.append(alarm)
        JFTAlarm.SaveChanges()
    }
    
    static func RemoveAlarm(row: Int)
    {
        AlarmStorage[row].removeAllNotifications()
        AlarmStorage.remove(at: row)
        JFTAlarm.SaveChanges()
    }
    
    func Serialize() -> Dictionary<String, Any>
    {
        return ["id":id,
                "Hour":Hour,
                "Minute":Minute,
                "On":On,
                "Repeats":Repeats,
                "Label":Lable]
    }
    
    func Deserialize(json: Dictionary<String, Any>)
    {
        id = json["id"] as! String
        Hour = json["Hour"] as! Int
        Minute = json["Minute"] as! Int
        On = json["On"] as! Bool
        Repeats = json["Repeats"] as! [Int]
        Lable = json["Label"] as! String
    }
    
    static func SaveChanges()
    {
        JFTUtilities.SaveLocalData(filename: "alarms", objectToSave: AlarmStorage)
    }
}
