//
//  JFTAddAlarmViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAddAlarmViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    private var hour = 0
    private var minute = 0
    @IBOutlet weak var ContentView: UIView!
    var ParentReference: JFTRefreshable?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ContentView.layer.cornerRadius = 15
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        ParentReference!.SetRefreshEvent()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 61
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return 24
        }
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var pickerLabel = UILabel()
        if let view = view
        {
            pickerLabel = view as! UILabel
        }
        pickerLabel.font = UIFont.systemFont(ofSize: 75)
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = (pickerView.tag == 1) ? "\(JFTFormatter.FormatMinutes(row))" : "\(row)"
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 0
        {
            hour = row
        }
        else
        {
            minute = row
        }
    }
    
    @IBAction func OnCancelButtonTouch(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnAddButtonTouch(_ sender: UIButton)
    {
        JFTAlarm.AddAlarm(alarm: JFTAlarm(hour: hour, minute: minute))
        OnCancelButtonTouch(sender)
    }
}
