//
//  GameViewController.swift
//  ParkgatePigeons
//
//  Created by Andrew Muncey on 12/06/2015.
//  Copyright (c) 2015 University of Chester. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


protocol GameViewControllerDelegate{
    func level(level: Int, completed: Bool)
}


class GameViewController: UIViewController, PigeonSceneDelegate {

    
    var gameViewControllerDelegate: GameViewControllerDelegate?
    
    var level = 1
    
    func level(level: Int, completed: Bool) {
        if !completed {
            navigationController?.popViewControllerAnimated(true)
        }
       
        gameViewControllerDelegate?.level(level, completed: completed)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            
            scene.pigeonSceneDelegate = self
            scene.level = level
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.size = skView.frame.size
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
       
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
