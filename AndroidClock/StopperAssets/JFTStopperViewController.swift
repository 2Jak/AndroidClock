//
//  JFTStopperViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 29/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTStopperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    private var mainTimer: Timer?
    private var secondaryTimer: Timer?
    private var animationTimer: Timer?
    private var resultArray: [[String]] = []
    private var mainStopper: JFTStopper = JFTStopper()
    private var secondaryStopper: JFTStopper = JFTStopper()
    private var animationLayer: CAShapeLayer?
    @IBOutlet weak var CircularView: UIView!
    @IBOutlet weak var StopperLabel: UILabel!
    @IBOutlet weak var ResultsTableView: UITableView!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var SplitButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ResultsTableView.delegate = self
        ResultsTableView.dataSource = self
        GoButton.setTitle("Pause", for: .selected)
        turnHelperButtonsOff()
        ResultsTableView.isHidden = true
        buildAnimationLayer()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! JFTStopperResultTableViewCell
        let result = resultArray[indexPath.row]
        resultCell.InitializeWith(count: result[0], segment: result[1], time: result[2])
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    @IBAction func OnResetButtonTouch(_ sender: UIButton)
    {
        turnHelperButtonsOff()
        resultArray = []
        ResultsTableView.reloadData()
        ResultsTableView.isHidden = true
        mainTimer = nil
        secondaryTimer = nil
        mainStopper.ResetStopper()
        secondaryStopper.ResetStopper()
        mainStopper.On = false
        secondaryStopper.On = false
        updateStopperLabel()
    }
    
    @IBAction func OnSplitButtonTouch(_ sender: UIButton)
    {
        if secondaryTimer == nil
        {
            let firstResult = JFTFormatter.FormatStopperToString(mainStopper)
            resultArray.append(["#1", firstResult, firstResult])
            addSecondaryTimer()
            ResultsTableView.isHidden = false
            ResultsTableView.reloadData()
        }
        else
        {
            resultArray.append(["#\(resultArray.count + 1)", JFTFormatter.FormatStopperToString(secondaryStopper), JFTFormatter.FormatStopperToString(mainStopper)])
            addSecondaryTimer()
            secondaryStopper.ResetStopper()
            ResultsTableView.reloadData()
        }
    }
    
    @IBAction func OnGoButtonTouch(_ sender: UIButton)
    {
        turnHelperButtonsOn()
        if !sender.isSelected
        {
            ResetButton.isHidden = true
            addAnimationTimer()
            mainTimer = Timer(timeInterval: 0.01, repeats: true, block: { _ in
                self.mainStopper.On = true
                self.mainStopper.ProcessTick()
                DispatchQueue.main.async {
                    self.updateStopperLabel()
                }
                if !self.mainStopper.On
                {
                    self.mainTimer!.invalidate()
                }
            })
            RunLoop.current.add(mainTimer!, forMode: .default)
        }
        else
        {
            SplitButton.isHidden = true
            ResetButton.isHidden = false
            if mainTimer != nil
            {
                mainTimer!.invalidate()
            }
            if secondaryTimer != nil
            {
                secondaryTimer!.invalidate()
            }
            if animationTimer != nil
            {
                animationTimer!.invalidate()
            }
        }
        GoButton.isSelected = !GoButton.isSelected
    }
    
    private func turnHelperButtonsOff()
    {
        ResetButton.isHidden = true
        SplitButton.isHidden = true
    }
    
    private func turnHelperButtonsOn()
    {
        ResetButton.isHidden = false
        SplitButton.isHidden = false
    }
    
    private func updateStopperLabel()
    {
        StopperLabel.text = JFTFormatter.FormatStopperToString(mainStopper)
        self.view.setNeedsDisplay()
    }
    
    private func addSecondaryTimer()
    {
        secondaryTimer = Timer(timeInterval: 0.01, repeats: true, block: { _ in
            self.secondaryStopper.On = true
            self.secondaryStopper.ProcessTick()
            if !self.secondaryStopper.On
            {
                self.secondaryTimer!.invalidate()
            }
        })
        RunLoop.current.add(secondaryTimer!, forMode: .default)
    }
    
    private func addAnimationTimer()
    {
        animationTimer = Timer(timeInterval: 1, repeats: true, block: { _ in
            self.animateStopper()
        })
        RunLoop.current.add(animationTimer!, forMode: .default)
    }
    
    private func buildAnimationLayer()
    {
        animationLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: (CircularView.center - CGPoint(x: 108.5, y: 35)), radius: 77, startAngle: (-CGFloat.pi / 2), endAngle: (1.5 * CGFloat.pi), clockwise: true)
        animationLayer!.path = circlePath.cgPath
        animationLayer!.strokeColor = UIColor.systemBlue.cgColor
        animationLayer!.fillColor = UIColor.clear.cgColor
        animationLayer!.lineWidth = 2
        animationLayer!.lineCap = .round
        animationLayer!.strokeEnd = 0.0
        CircularView.layer.addSublayer(animationLayer!)
    }
    
    private func animateStopper()
    {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = true
        animationLayer!.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
