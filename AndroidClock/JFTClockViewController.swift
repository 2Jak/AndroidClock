//
//  JFTClockViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 30/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTClockViewController: UIViewController
{
    private var clockTimer: Timer?
    @IBOutlet weak var ClockTimeLabel: UILabel!
    @IBOutlet weak var ClockDateLabel: UILabel!
    
    override func loadView()
    {
        super.loadView()
        setupTimer()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateTime()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupTimer()
        updateTime()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        clockTimer!.invalidate()
    }
    
    private func updateTime()
    {
        ClockTimeLabel.text = JFTFormatter.FormatedTimeString(date: Date())
        ClockDateLabel.text = JFTFormatter.FormatedDateString(date: Date())
        self.view.setNeedsDisplay()
    }
    
    private func setupTimer()
    {
        if clockTimer != nil
        {
            clockTimer!.invalidate()
        }
        clockTimer = Timer(timeInterval: 60, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        RunLoop.current.add(clockTimer!, forMode: .default)
    }
    
    @objc private func timerUpdate()
    {
        ClockTimeLabel.text = JFTFormatter.FormatedTimeString(date: Date())
        self.view.setNeedsDisplay()
    }
}
