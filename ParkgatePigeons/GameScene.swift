//
//  GameScene.swift
//  ParkgatePigeons
//
//  Created by Andrew Muncey on 12/06/2015.
//  Copyright (c) 2015 University of Chester. All rights reserved.
//

import SpriteKit



protocol PigeonSceneDelegate{
    func level(level: Int, completed: Bool)
}

class GameScene: SKScene, PigeonDelegate {
    
    
    var pigeonSceneDelegate: PigeonSceneDelegate?
    
    var seedInterval = 1.0
    var levelDuration = 10
    var level = 1
    
    private var pigeonCount = 0
    private var score = 0
    private var hits = 0
    private var seedTimer = NSTimer()
    private var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    private var levelLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    
    override func didMoveToView(view: SKView) {
 
        backgroundColor = UIColor.blackColor()
        
        var background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        var scaleFactor = background.size.width / frame.size.width
        background.size.width = frame.size.width
        background.size.height = background.size.height / scaleFactor
        addChild(background)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 12
        scoreLabel.position = CGPointMake(10, 10)
        scoreLabel.horizontalAlignmentMode = .Left
        addChild(scoreLabel)
        
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 12
        levelLabel.position = CGPointMake(frame.width-10, 10)
        levelLabel.horizontalAlignmentMode = .Right
        addChild(levelLabel)
    
        seedInterval = 1.0 - Double(level)/100.0
        
        startGame()
    }
    
    func seedPigeon(){
        pigeonCount++
        
        //randomly descide to fly the other way (1 in 2)
        var flyRightToLeft = (1 == arc4random_uniform(2))
        
        var sprite = Pigeon()
        
        //define possible starting positions
        var leftStartPosition = 0 - sprite.frame.size.width
        var rightStartPosition = frame.size.width + (0.5 * sprite.frame.size.width)
        
        //set the starting position (either offset all the way to the right, or the sprite's width offset to thelft)
        //this line of code is essentially a compact form of an 'if' statement known as a ternary operator
        var xPosition = flyRightToLeft ? rightStartPosition : leftStartPosition
        
        //if flying the pother way, we can get a -1 value to modify the flying direction
        var directionModifier = flyRightToLeft ? -1.0 : +1.0
        
        //get a position between 100 pixels high and 400 to start the pigeon
        var yPosition = CGFloat(arc4random_uniform(300) + 200)
        
        //offset for tall screens
        yPosition += CGRectGetMaxX(frame) - 480.0
        
        //set the position
        sprite.position = CGPointMake(xPosition, yPosition)
        
        //get a random duration for animation
        var randomduration = Float((arc4random_uniform(100) + 1)/100)
        
        //make faster as game progresses (shorter duration)
        var durationIncrement = abs((100.0 - Float(pigeonCount)) / 100.0)
        
        //combine durations
        var duration = randomduration + durationIncrement + 0.5
        
        /******Add duration for test *********/
        duration += 1
        
        //determine flight movement on X axis
        var flightMotion : CGFloat =  frame.size.width + (2.0 * sprite.size.width)
        
        //modify direction
        flightMotion *= CGFloat(directionModifier)
        
        //create a flying animation
        var fly = SKAction.moveByX(flightMotion, y: CGFloat(0.0), duration: NSTimeInterval(duration))
        
        //run animation
        sprite.runAction(fly)
        
        //place it on screen
        addChild(sprite)
        
        //ensure the pigeon delegates to the game when killed
        sprite.delegate = self

    }
    
    func startGame(){
        
        //reset counters
        hits = 0
        score = 0
        pigeonCount = 0
        
        levelLabel.text = "Level: \(level)"
        
        //introduce the level
        var introLabel = SKLabelNode(fontNamed: "Chalkduster")
        introLabel.text = "Level \(level)"
        introLabel.fontSize = 40
        introLabel.position = CGPointMake(frame.width/2, frame.height/2)
        introLabel.horizontalAlignmentMode = .Center
        introLabel.color = SKColor(white: 0, alpha: 1)
        addChild(introLabel)
        
        //create series of animations
        var wait = SKAction.waitForDuration(0.5)
        var fadeOut = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        //this animation will set off the timers
        var start = SKAction.runBlock({
            self.seedTimer = NSTimer.scheduledTimerWithTimeInterval(self.seedInterval, target: self, selector: "seedPigeon", userInfo: nil, repeats: true)
            NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.levelDuration), target: self, selector: "stopSeeding" , userInfo: nil, repeats: false)
            })
        
        //run the animations in order
        introLabel.runAction(SKAction.sequence([wait,fadeOut,start]))
        
    }
    
    
    
    func stopSeeding(){
        seedTimer.invalidate()
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "gameOver", userInfo: nil, repeats: false)
    }
    
    func gameOver(){
        
        if hits == pigeonCount{
            level++
            startGame()
            pigeonSceneDelegate?.level(level, completed: true)
        }
        else{
            pigeonSceneDelegate?.level(level, completed: false)
        }
        
    }
    
    
    func pigeonKilled() {
        score += 10
        hits++
        scoreLabel.text = "Score: \(score)"
    }
}
