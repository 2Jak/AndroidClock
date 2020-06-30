//
//  JFTRegAlarmTableViewCell.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTRegAlarmTableViewCell: UITableViewCell
{
    @IBOutlet weak var AlarmTimeLabel: UILabel!
    @IBOutlet weak var WeekdayRepeatsLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AlarmOnSwitch: UISwitch!
    var AlarmReference: JFTAlarm?
    
    func InitializeWith(alarm: JFTAlarm)
    {
        AlarmReference = alarm
        AlarmTimeLabel.text = "\(alarm.Hour):\(JFTFormatter.FormatMinutes(alarm.Minute))"
        WeekdayRepeatsLabel.text = ""
        for weekday in alarm.Repeats
        {
            WeekdayRepeatsLabel.text! += " " + JFTUtilities.WeekdayLetterFor(int: weekday)
        }
        TitleLabel.text = alarm.Lable
        AlarmOnSwitch.isOn = alarm.On
    }
    
    @IBAction func OnAlarmSwitchValueChange(_ sender: UISwitch)
    {
        AlarmReference!.On = sender.isOn
        JFTAlarm.SaveChanges()
    }
}
