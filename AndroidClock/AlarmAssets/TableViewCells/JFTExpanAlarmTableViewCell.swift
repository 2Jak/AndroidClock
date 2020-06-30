//
//  JFTExpanAlarmTableViewCell.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTExpanAlarmTableViewCell: UITableViewCell, UITextFieldDelegate
{
    private var internalRowReminder: Int?
    @IBOutlet weak var AlarmTimeLabel: UILabel!
    @IBOutlet weak var AlarmOnSwitch: UISwitch!
    @IBOutlet weak var AlarmLabelTextField: UITextField!
    var AlarmReference: JFTAlarm?
    var ParentReference: JFTRefreshable?
    
    
    func InitializeWith(alarm: JFTAlarm, row: Int)
    {
        AlarmLabelTextField.delegate = self
        internalRowReminder = row
        AlarmReference = alarm
        for i in 1...7
        {
            let weekdayButton = self.viewWithTag(i) as! UIButton
            weekdayButton.setBackgroundImage(UIImage(named: "circle.fill"), for: .selected)
        }
        for weekday in alarm.Repeats
        {
           let weekdayButton = self.viewWithTag(weekday) as! UIButton
            weekdayButton.isSelected = true
        }
        AlarmLabelTextField.text = alarm.Lable
        AlarmTimeLabel.text = "\(alarm.Hour):\(JFTFormatter.FormatMinutes(alarm.Minute))"
        AlarmOnSwitch.isOn = alarm.On
    }
    
    @IBAction func OnDeleteButtonTouch(_ sender: UIButton)
    {
        JFTAlarm.RemoveAlarm(row: internalRowReminder!)
        ParentReference!.SetRefreshEvent()
    }
    
    @IBAction func OnAlarmSwitchValueChanged(_ sender: UISwitch)
    {
        AlarmReference!.On = sender.isOn
        JFTAlarm.SaveChanges()
    }
    
    @IBAction func OnWeekdayRepeatTouch(_ sender: UIButton)
    {
        if !sender.isSelected
        {
            AlarmReference!.Repeats.append(sender.tag)
        }
        else
        {
            AlarmReference!.RemoveRepeat(weekday: sender.tag)
        }
        sender.isSelected = !sender.isSelected
        JFTAlarm.SaveChanges()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        AlarmReference!.Lable = textField.text!
        JFTAlarm.SaveChanges()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    }
}
