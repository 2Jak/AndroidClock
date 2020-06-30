//
//  JFTTimerView.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTTimerView: UIView, UITextFieldDelegate
{
    private static var xibName = "JFTTimerView"
    private var initialTickCount: Int = 0
    private var currentTickPosition: Int = 0
    private var animationLayer: CAShapeLayer?
    @IBOutlet var view: UIView!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var HoursLabel: UILabel!
    @IBOutlet weak var MinutesLabel: UILabel!
    @IBOutlet weak var SecondsLabel: UILabel!
    @IBOutlet weak var TimerLabelTextField: UITextField!
    var TimerReference: JFTTimer?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(JFTTimerView.xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        TimerLabelTextField.delegate = self
    }
    
    func InitializeWith(timer: JFTTimer)
    {
        TimerReference = timer
        TimerLabelTextField.text = timer.Label
        updateTextFields()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        TimerReference!.Label = textField.text!
        JFTTimer.SaveChanges()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    }
    
    @IBAction func OnResetButtonTouch(_ sender: UIButton)
    {
        TimerReference!.ResetTimer()
        updateTextFields()
        JFTTimer.SaveChanges()
        animationLayer!.removeFromSuperlayer()
        animationLayer = nil
    }
    
    func ProcessTimerTick() -> Bool
    {
        let timerFinished = TimerReference!.ProcessTimerTick()
        updateTextFields()
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        if timerFinished
        {
            ResetButton.isHidden = false
            animationLayer!.removeFromSuperlayer()
            animationLayer = nil
        }
        return timerFinished
    }
    
    func StartAnimation()
    {
        ResetButton.isHidden = true
        if animationLayer == nil
        {
            createAnimationLayer()
        }
        else
        {
            let pausedTime = animationLayer!.timeOffset
            animationLayer!.speed = 1.0
            animationLayer!.timeOffset = 0.0
            animationLayer!.beginTime = 0.0
            let timeSincePause = animationLayer!.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            animationLayer!.beginTime = timeSincePause
        }
    }
    
    func PauseAnimation()
    {
        ResetButton.isHidden = false
        let pausedTime = animationLayer!.convertTime(CACurrentMediaTime(), from: nil)
        animationLayer!.speed = 0.0
        animationLayer!.timeOffset = pausedTime
    }
    
    override func draw(_ rect: CGRect)
    {
        UIColor.white.setFill()
        UIRectFill(rect)
        let resizedRect = rect - 2.0
        drawGrayCircle(resizedRect)
    }

    private func drawGrayCircle(_ rect: CGRect)
    {
        let circlePath = UIBezierPath(ovalIn: rect)
        UIColor.darkGray.setStroke()
        circlePath.lineWidth = 2
        circlePath.stroke()
    }
    
    private func updateTextFields()
    {
        HoursLabel.text = JFTFormatter.FormatMinutes(TimerReference!.CurrentHour)
        MinutesLabel.text = JFTFormatter.FormatMinutes(TimerReference!.CurrentMinute)
        SecondsLabel.text = JFTFormatter.FormatMinutes(TimerReference!.CurrentSecond)
    }
    
    private func createAnimationLayer()
    {
        animationLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 77, startAngle: (-CGFloat.pi / 2), endAngle: (1.5 * CGFloat.pi), clockwise: true)
        animationLayer!.path = circlePath.cgPath
        animationLayer!.strokeColor = UIColor.systemBlue.cgColor
        animationLayer!.fillColor = UIColor.clear.cgColor
        animationLayer!.lineWidth = 2
        animationLayer!.lineCap = .round
        animationLayer!.strokeEnd = 0.0
        layer.addSublayer(animationLayer!)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = TimerReference!.Duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        animationLayer!.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
