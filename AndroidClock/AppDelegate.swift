//
//  AppDelegate.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 26/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        if UserDefaults.standard.object(forKey: "LastAlarmCount") == nil
        {
            UserDefaults.standard.set(0, forKey: "LastAlarmCount")
        }
        JFTAlarm.AlarmStorage = JFTUtilities.LoadLocalData(filename: "alarms") ?? []
        JFTTimer.TimerStorage = JFTUtilities.LoadLocalData(filename: "timers") ?? []
        return true
    }
}

