//
//  JFTStopperResultTableViewCell.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 29/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTStopperResultTableViewCell: UITableViewCell
{
    @IBOutlet weak var ResultCountLabel: UILabel!
    @IBOutlet weak var SegmentTimeLabel: UILabel!
    @IBOutlet weak var TotalTimeLabel: UILabel!
    
    func InitializeWith(count: String, segment: String, time: String)
    {
        ResultCountLabel.text = count
        SegmentTimeLabel.text = segment
        TotalTimeLabel.text = time
    }
}
