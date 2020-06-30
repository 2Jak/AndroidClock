//
//  JFTAddTimerViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 29/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAddTimerViewController: UIViewController, UITextFieldDelegate
{
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var HoursTextField: UITextField!
    @IBOutlet weak var MinutesTextField: UITextField!
    @IBOutlet weak var SecondsTextField: UITextField!
    var ParentReference: JFTRefreshable?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ContentView.layer.cornerRadius = 15.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        checkTextFieldAndApplyChanges(textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        checkTextFieldAndApplyChanges(textField)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.ParentReference!.SetRefreshEvent()
    }
    
    @IBAction func OnCancelButtonTouch(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnAddButtonTouch(_ sender: UIButton)
    {
        JFTTimer.AddTimer(timer: JFTTimer(hour: hours, minute: minutes, second: seconds))
        OnCancelButtonTouch(sender)
    }
    
    private func ensureDigitsInAcceptedRange(_ textField: UITextField)
    {
        if Int(textField.text!) != nil
        {
            switch textField.tag
            {
                case 0:
                    if Int(textField.text!)! > 99
                    {
                        textField.text = "99"
                    }
                    break
                default:
                    if Int(textField.text!)! > 59
                    {
                        textField.text = "59"
                    }
                    break
            }
            if Int(textField.text!)! < 0
            {
                textField.text = "0"
            }
        }
    }
    
    private func checkTextFieldAndApplyChanges(_ textField: UITextField)
    {
        ensureDigitsInAcceptedRange(textField)
        switch textField.tag
        {
            case 0:
                hours = Int(textField.text!) ?? 0
                break
            case 1:
                minutes = Int(textField.text!) ?? 0
                break
            case 2:
                seconds = Int(textField.text!) ?? 0
                break
            default:
                break
        }
    }
}
