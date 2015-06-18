//
//  LevelSelectViewController.swift
//  ParkgatePigeons
//
//  Created by Andrew Muncey on 18/06/2015.
//  Copyright (c) 2015 University of Chester. All rights reserved.
//

import UIKit

class LevelSelectViewController : UITableViewController, GameViewControllerDelegate {
    
    
    func level(level: Int, completed: Bool) {
        if completed && level > maxLevel{
            maxLevel = level - 1
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(level, forKey: "highScore")
            tableView.reloadData()
        }
    }
    
    
    var maxLevel = 0
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        maxLevel = defaults.integerForKey("highScore")
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxLevel+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.textLabel?.text = "Level \(indexPath.row+1)"
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameViewController = segue.destinationViewController as! GameViewController
        gameViewController.level = tableView.indexPathForSelectedRow()!.row + 1
        gameViewController.gameViewControllerDelegate = self
    }
    
}