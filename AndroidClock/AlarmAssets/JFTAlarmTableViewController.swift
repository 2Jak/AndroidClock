//
//  JFTAlarmTableViewController.swift
//  AndroidClock
//
//  Created by hyperactive hi-tech ltd on 26/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAlarmTableViewController: UITableViewController, JFTRefreshable
{
    private var lastSelectedRow: Int = -1
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAlarm"
        {
            let castDestination = segue.destination as! JFTAddAlarmViewController
            castDestination.ParentReference = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return JFTAlarm.AlarmStorage.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
            case lastSelectedRow:
                let expandedCell = tableView.dequeueReusableCell(withIdentifier: "expandedCell") as! JFTExpanAlarmTableViewCell
                let row = indexPath.row
                expandedCell.InitializeWith(alarm: JFTAlarm.AlarmStorage[row], row: row)
                expandedCell.ParentReference = self
                return expandedCell
            case JFTAlarm.AlarmStorage.count:
                let addCell = tableView.dequeueReusableCell(withIdentifier: "addCell")!
                return addCell
            default:
                let regCell = tableView.dequeueReusableCell(withIdentifier: "regCell") as! JFTRegAlarmTableViewCell
                regCell.InitializeWith(alarm: JFTAlarm.AlarmStorage[indexPath.row])
                return regCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row
        {
            case lastSelectedRow:
                return 252
            case JFTAlarm.AlarmStorage.count:
                return 61
            default:
                return 85
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == lastSelectedRow
        {
            lastSelectedRow = -1
        }
        else
        {
            lastSelectedRow = indexPath.row
        }
        tableView.reloadData()
    }
    
    func SetRefreshEvent()
    {
        DispatchQueue.main.async {
            self.lastSelectedRow = -1
            self.tableView.reloadData()
        }
    }
}
