//
//  JFTTimersViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 28/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTTimersViewController: UIViewController, UIScrollViewDelegate, JFTRefreshable
{
    private static var timer: Timer?
    private var selectedTimer: JFTTimerView?
    {
        get
        {
            return TimersPresentorScrollView.subviews[currentPage - 1] as? JFTTimerView
        }
    }
    private var currentPage: Int = 0
    @IBOutlet weak var TimersPresentorScrollView: UIScrollView!
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GoButton.setTitle("Pause", for: .selected)
        onZeroTimerCount()
        layoutTimerViews()
        currentPage = calculatePageFrom(offset: TimersPresentorScrollView.contentOffset)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        JFTTimer.SaveChanges()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        currentPage = calculatePageFrom(offset: scrollView.contentOffset)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addSegue"
        {
            let castDestination = segue.destination as! JFTAddTimerViewController
            castDestination.ParentReference = self
        }
    }

    @IBAction func OnGoButtonTouch(_ sender: UIButton)
    {
        if sender.isSelected
        {
            JFTTimersViewController.timer!.invalidate()
            selectedTimer!.PauseAnimation()
        }
        else
        {
            JFTTimersViewController.timer = Timer(timeInterval: 1, repeats: true, block: {_ in
                if self.selectedTimer!.ProcessTimerTick()
                {
                    JFTTimersViewController.timer!.invalidate()
                    self.GoButton.isSelected = !self.GoButton.isSelected
                }
            })
            JFTTimersViewController.timer!.tolerance = 0.1
            RunLoop.current.add(JFTTimersViewController.timer!, forMode: .default)
            selectedTimer!.StartAnimation()
        }
        GoButton.isSelected = !GoButton.isSelected
    }
    @IBAction func OnDeleteButtonTouch(_ sender: UIButton)
    {
        JFTTimer.RemoveTimer(row: currentPage - 1)
        onZeroTimerCount()
        SetRefreshEvent()
    }
    
    private func onZeroTimerCount()
    {
        GoButton.isEnabled = !(JFTTimer.TimerStorage.count == 0)
        DeleteButton.isHidden = (JFTTimer.TimerStorage.count == 0)
    }
    
    private func recalculateContentSize()
    {
        let width = TimersPresentorScrollView.contentSize.width
        let height = TimersPresentorScrollView.frame.size.height * CGFloat(TimersPresentorScrollView.subviews.count)
        TimersPresentorScrollView.contentSize = CGSize(width: width, height: height)
    }
    
    private func layoutTimerViews()
    {
        cleanScrollView()
        let xPosition: CGFloat = (TimersPresentorScrollView.frame.size.width / 2) - 79.0
        var yPoistion: CGFloat = (TimersPresentorScrollView.frame.size.height / 2) - 79.0
        for timer in JFTTimer.TimerStorage
        {
            let timerView = JFTTimerView(frame: CGRect(x: xPosition, y: yPoistion, width: 158.0, height: 158.0))
            timerView.InitializeWith(timer: timer)
            TimersPresentorScrollView.addSubview(timerView)
            yPoistion += TimersPresentorScrollView.frame.size.height
        }
        recalculateContentSize()
    }
    
    private func cleanScrollView()
    {
        for view in TimersPresentorScrollView.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    private func calculatePageFrom(offset: CGPoint) -> Int
    {
        if offset.y < TimersPresentorScrollView.frame.height
        {
            return 1
        }
        return Int(TimersPresentorScrollView.contentSize.height / offset.y)
    }
    
    func SetRefreshEvent()
    {
        layoutTimerViews()
        onZeroTimerCount()
    }
}
